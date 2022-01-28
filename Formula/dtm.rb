class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "http://d.dtm.pub"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "fd8726ad2b0d93f14343b34b4f415e830ac2086330b2d02fb1a78d6c21062b0c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de5f168ba7b8a768812001041d4a6a65ae88148b1c5b56ada9d8dbea5e082ca3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8e4a7db32602938bdb9b9325f42f85e55665451960f0b8963eeddafec041ca1"
    sha256 cellar: :any_skip_relocation, monterey:       "5e0f27ead1a225fd31c86e7d9497cd498429a659a63665b96968bd28f216d4b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f675f077b6bf50094009946fa416dcc02cca23e6a6a1d6da81ca50acc71e157f"
    sha256 cellar: :any_skip_relocation, catalina:       "d2867137f821bf419c04e2d5791a4687e2115f97e3f8f59c97a688cd1f48ebd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d331825f105b5977863e20a7a24fb1e633831d5ad20502f22ceae02ff4f709db"
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
