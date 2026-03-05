class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.64.1.tar.gz"
  sha256 "b03bd6a803e0328a55620272ea5369852c28f1706b7672a310353f37621e6ae7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a517fa583dee7d672cf584805843beb38ab920783953cd1b43766688e108d550"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a517fa583dee7d672cf584805843beb38ab920783953cd1b43766688e108d550"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a517fa583dee7d672cf584805843beb38ab920783953cd1b43766688e108d550"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dc071a5d6e123ccb175ea358be5992b9ca8d4594c045bef8b415e07c788723b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3d9fe40b9d655a4b59ef02232dd10fcd2fc522e9b406284d5181915c78cfce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b2e90de8bbe29a0a831440d29f9abe40d8e3ee8c50964cce0e39958ac53aab3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    # The program is a TUI so we need to spawn it and close the process after it creates the database file.
    pid = spawn(bin/"micasa", "--demo", testpath/"demo.db")
    sleep 3
    Process.kill("TERM", pid)
    Process.wait(pid)

    assert_path_exists testpath/"demo.db"
  end
end
