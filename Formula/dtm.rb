class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "http://d.dtm.pub"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "2e5545885688f6e337ead2fb0c81eb31bbfd7cb316f5a77c7e4d27600021d5ec"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74c3822e422119e0ad3e16970e53987d7b3f08170a77102cea1fc2115deb1cd2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f4a350e30367221bce865f91828eeff33b904cc5eb43954cea9850cce67c880"
    sha256 cellar: :any_skip_relocation, monterey:       "23251f4b7b7c9a1f354041b8d8f79b1df385b5f2730cc8fb939e0c15d3bc22d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "470d0d2a4635f003c20df4ebd2d5a6117e27c2452021a1f8a8f0619c2cc4fc98"
    sha256 cellar: :any_skip_relocation, catalina:       "977955f4154f03436fda2f5ea1ebfcd78b7e5910e18d8a27d440a3d7825ec582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85b05318f42aef6f64e6ab9129ede3866b1e20202d8faabe912be6d462aaa87e"
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
