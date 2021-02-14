class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.6.0.tar.gz"
  sha256 "21eee14187993b1deee9b84250f41616628daf3319b8d19959e9ed2399739469"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8bdc0f756df73dd79402ad8cb101cc6e7ec10f4d20f8aeaa1f209f95e947f24d"
    sha256 cellar: :any_skip_relocation, big_sur:       "1240fc04acd18929f2f849b9f943242d38553ee01e29bd6907f285557f21b22c"
    sha256 cellar: :any_skip_relocation, catalina:      "441da39e12928f5dc6e196ebf7fe7f4e6aad1d574b2eee58916d99add690b382"
    sha256 cellar: :any_skip_relocation, mojave:        "156489e97b814b3f60056af9057547de9700c0c49aeb0eab8cbdfd667818a91d"
  end

  depends_on "go" => :build

  conflicts_with "coreutils", because: "both install `gdu` binaries"

  def install
    time = Time.new
    user = Utils.safe_popen_read("id", "-u", "-n")

    ldflags = %W[
      -s -w
      -X 'github.com/dundee/gdu/build.Version=v#{version}'
      -X 'github.com/dundee/gdu/build.Time=#{time}'
      -X 'github.com/dundee/gdu/build.User=#{user}'
    ]

    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" ")
  end

  test do
    mkdir_p testpath/"test_dir"
    (testpath/"test_dir"/"file1").write "hello"
    (testpath/"test_dir"/"file2").write "brew"

    assert_match version.to_s, shell_output("#{bin}/gdu -v")
    assert_match "colorized", shell_output("#{bin}/gdu --help 2>&1")
    assert_match "4.0 KiB file1", shell_output("#{bin}/gdu --non-interactive --no-progress #{testpath}/test_dir 2>&1")
  end
end
