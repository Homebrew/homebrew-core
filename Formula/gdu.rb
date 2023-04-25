class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.23.0.tar.gz"
  sha256 "7fa8fbfb33e3abe71f89e90aac84111e49fb226ffba145822e1f2e0072668d70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca699864d0a2a5318bb544be4e5db330729df77331fb818d878d4e7d66f55f44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca699864d0a2a5318bb544be4e5db330729df77331fb818d878d4e7d66f55f44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca699864d0a2a5318bb544be4e5db330729df77331fb818d878d4e7d66f55f44"
    sha256 cellar: :any_skip_relocation, ventura:        "a78b5341b03c32886b8096da14f75d0d3f3356ac31d424e60004b882500c4ddf"
    sha256 cellar: :any_skip_relocation, monterey:       "a78b5341b03c32886b8096da14f75d0d3f3356ac31d424e60004b882500c4ddf"
    sha256 cellar: :any_skip_relocation, big_sur:        "a78b5341b03c32886b8096da14f75d0d3f3356ac31d424e60004b882500c4ddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05b8d94a771cff89786a6e857fa99d7019e2b1cfa3b7ae1c2e4618d31b4dba5b"
  end

  depends_on "go" => :build

  conflicts_with "coreutils", because: "both install `gdu` binaries"

  def install
    user = Utils.safe_popen_read("id", "-u", "-n")
    major = version.major

    ldflags = %W[
      -s -w
      -X "github.com/dundee/gdu/v#{major}/build.Version=v#{version}"
      -X "github.com/dundee/gdu/v#{major}/build.Time=#{time}"
      -X "github.com/dundee/gdu/v#{major}/build.User=#{user}"
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gdu"
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
