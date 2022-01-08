class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "http://d.dtm.pub"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "c00fe2e143938989b1090b3ce5ec6076cb5be331482293849bae8016454af1f4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27515ae85aa4bb2555682d3972189fe95fef7768139d334bcafb5831e2254c8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4412c0fc67d6810fa6a5e15e97a31a34f5cc95fc8263ed0fdcc694157aa7f49"
    sha256 cellar: :any_skip_relocation, monterey:       "cba92fe3e79095473662aa418e32e90861fff2996c1152d6d564cdce1c3debe8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b681bbdffec8d09e90851a4652e90ee60de476501b66815528cf136e54bc3967"
    sha256 cellar: :any_skip_relocation, catalina:       "0f91316257152a4ee894d843aaf9e41459ef3467bcfe2a7212d1b0cfc8237e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "832c23f75ecf6a381b3fa74176aba70978a8f1c039feefb9f71d333265c1b67f"
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
