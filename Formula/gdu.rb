class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.9.0.tar.gz"
  sha256 "699583aa9ad999a7b9ee497bd21bc066e5bb411a13ed485cc99f03b9a9357293"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1cb6af88b27b6b7f4a2b080f97373465dd6a34d2129f50bac624b46f4a13e3fd"
    sha256 cellar: :any_skip_relocation, big_sur:       "84844a5c7474b22fc6909d1f77de80f72f9f0f5916bd5b9ef424331d68570ff9"
    sha256 cellar: :any_skip_relocation, catalina:      "d2bc6344e000a6d386481a73c3766208ab569a7284cba9e54c6f3e18c461bde1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53c9406a233a251330d8978a96af3c03dce3709e327721e756cb3ca0b61729c4"
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
    ].join(" ")

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
