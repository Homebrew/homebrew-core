class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.17.0.tar.gz"
  sha256 "918a92b6819c0de55154013813f5f989e222d63285eb203970df9869cd1571dc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcc5fdbb25bf9fa83140b7bdfeb31d14512b5b1af5f85c9ffa3112f48db123be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c701611eba64c18980ced0c2f0619938367d2e46f5828dc6f816ec6736799422"
    sha256 cellar: :any_skip_relocation, monterey:       "207ece508411210b67ebdf0004295b32cf32a93cd97d6cd0f9cb612dfc9a100f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e6adaf465568981134f06775ce50c3691f4a57ce6166c9e350c1b4ece798171"
    sha256 cellar: :any_skip_relocation, catalina:       "8a720bb658da6c9865fa1dc4d72af40eea884a23cb4fae5774092966c020b9a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e85e66cbc0016911f4f730d4b62482e0608e5a18434b2acae93ad39f82fb5b3f"
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
