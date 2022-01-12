class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "http://d.dtm.pub"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "6a4154260a99c3717d1a11922181129cb11fc27ec2b645a7892d10fc1b58ad39"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9f5a1aa9b893695172bcd6499a688f1b9c0e4be857a1c0b2ffa3ac7e4464379"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76f40ec2ff04c7df8135a9c2a64fcee8033ffbd3779d087019d8e1ba3c257087"
    sha256 cellar: :any_skip_relocation, monterey:       "831b2a5e23cfde933868ad625deaf31a74a7542a5370953125e00329394e089c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b79f88ec6601177db187ac6a9ed6dd10382154ac983db888294957c8e95e8e9"
    sha256 cellar: :any_skip_relocation, catalina:       "4fb750d8b586293370ef189856c2d3abf432c02c97fea0d93803bf9b1c393012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "981bfe930346a212474b4e7742b7e960dadfb5dac0ce5e5ec6b5e632722bde7d"
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
