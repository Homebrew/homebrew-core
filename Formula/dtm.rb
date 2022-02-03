class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "http://d.dtm.pub"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "73c2af8d6ac52d4879f69a40fa9250805a1a82b61781b39a21481076844c3ce6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "242a0b5df99811d2d367512381935f8823dcf9ea66c0bca60b073e82153a7c63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71c0d0d4170018bb6652339be12437c9cc84c7638964a4600ed872b30c0aa719"
    sha256 cellar: :any_skip_relocation, monterey:       "0b1c2b22e9e0ae1eb554355d5ceaacd52cf944540f0aead22dce7eca83b2d1fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "173f6774898d902a170fd282ad8dd0dc82c4be406dfb68454d9e2a65a3b4a8e5"
    sha256 cellar: :any_skip_relocation, catalina:       "03a05c42d79c0df17184ca0bae0a90a1b695f8f20d0c6b68b99c56c30202ebc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73a707cdd55363a4923be87a738b8bcbe692150ef01c1f0ddc313ed37875ea19"
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
