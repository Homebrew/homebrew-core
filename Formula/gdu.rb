class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.6.5.tar.gz"
  sha256 "a6a9be5a29c896814c2266389b7ec76d2f4ad55eee9bb156cf19d77f425ba3cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fefa58588a16476c7b901ecec6ad28fd1c1249d017c79e800c829a4df6a341b2"
    sha256 cellar: :any_skip_relocation, big_sur:       "2802587242069db0b927733f3e1921fd2c72cdce4737626b5e4156448f639b1e"
    sha256 cellar: :any_skip_relocation, catalina:      "3738cc3a4692d14d631b67faf8651e07a8235fe824aa513fd30573118912ef7c"
    sha256 cellar: :any_skip_relocation, mojave:        "ae35fee79772d0a3770c8e6cf678cd685a6322dfe8257bb9228b64fd8fe32f9a"
  end

  depends_on "go" => :build

  conflicts_with "coreutils", because: "both install `gdu` binaries"

  def install
    time = Time.new
    user = Utils.safe_popen_read("id", "-u", "-n")

    ldflags = %W[
      -s -w
      -X 'github.com/dundee/gdu/v4/build.Version=v#{version}'
      -X 'github.com/dundee/gdu/v4/build.Time=#{time}'
      -X 'github.com/dundee/gdu/v4/build.User=#{user}'
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
