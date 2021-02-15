class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.6.1.tar.gz"
  sha256 "e34d1311be160127e3ac13fbceb1ab554546ea26cbfb8270254323b98be2b08c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "12cdac328da92b4d9dea810e749300fe0fbdcfe85e27dd9f846496b41a7560f9"
    sha256 cellar: :any_skip_relocation, big_sur:       "c23604003df6802b576d7c0f190317ad8cac7698e021b001e52e3e7444d0ddc2"
    sha256 cellar: :any_skip_relocation, catalina:      "3d61fcfafcf993cbf273fe15d5e01b292fb522c82d4e715859f956230bfd4fed"
    sha256 cellar: :any_skip_relocation, mojave:        "8f5f75d0105b1bb27c205c904bb291631deb816f2b5bc020aca7e0e94b4c5bd6"
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
