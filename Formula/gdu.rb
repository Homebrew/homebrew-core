class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.13.1.tar.gz"
  sha256 "2fa09d79e84a1ec74db0c6bf006570f42ad3ffebbccfe98a1d14a0559892fb78"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aee1297e66f999d18647dfe143645ebbdb1fef05cada6fbc6a2f96394289af27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d00ce129ad97a6da5ede575f3a59de1a90305b8aa2b7ec72f6685a68e0e30e8"
    sha256 cellar: :any_skip_relocation, monterey:       "f76de92e24299d44ae11090c48e8f847d54901ddbc295fce0b36636bbadf9ebe"
    sha256 cellar: :any_skip_relocation, big_sur:        "4064c31b757171eda7db19d40cefe2e7e0add14f95918a7b5895daca99e866d0"
    sha256 cellar: :any_skip_relocation, catalina:       "cc7061f2c0017148bf9e7714c66555a98224e6f7e2f898c98436a4e13b61c509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18f4d3bbaf20f1458c2ae7e32901fa6015dc441a80849271173ea9f06a73d260"
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
