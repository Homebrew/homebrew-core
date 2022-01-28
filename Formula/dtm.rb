class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "http://d.dtm.pub"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "fd8726ad2b0d93f14343b34b4f415e830ac2086330b2d02fb1a78d6c21062b0c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63cbeea1b6bf256131cb4d0f546d0621d88e5edaeb8676a20c9e242daf78e28e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a07b34b2c32254616f7d94e366013bcf26baee8bbc64b2bc9b755199c18c23d"
    sha256 cellar: :any_skip_relocation, monterey:       "80e0f30516790ad16429d3f159b3a4593507b91e93761b52353d9eb919d9a936"
    sha256 cellar: :any_skip_relocation, big_sur:        "45d0e9511b7ba65ef5ce6eb34c69c8aaea8f88fc35311158c26255e5f2391198"
    sha256 cellar: :any_skip_relocation, catalina:       "5569745496c642593a93ea2d9003fb24dc651b3d25d629671e3f048d3f724c7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78967056121a64b3dca831fdc6027a16cef61f6bbbe4c0d7512ccd8847cd7ea7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dtm-qs"), "qs/main.go"
  end

  test do
    assert_match "dtm version: v#{version}", shell_output("#{bin}/dtm -v")
    dtm_pid = fork do
      exec bin/"dtm"
    end
    # sleep to let dtm get its wits about it
    sleep 5
    assert_match "succeed", shell_output("#{bin}/dtm-qs 2>&1")
  ensure
    # clean up the dtm process before we leave
    Process.kill("HUP", dtm_pid)
  end
end
