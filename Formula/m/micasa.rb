class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "decacb824cd7feae17608fafbde0976d49dc48d202f4ce438a45da3078bebfb6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9d903d9fb503e5dd80bf8bcdf2b07306d6a998c9095bc964ce28198cec6c052"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9d903d9fb503e5dd80bf8bcdf2b07306d6a998c9095bc964ce28198cec6c052"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9d903d9fb503e5dd80bf8bcdf2b07306d6a998c9095bc964ce28198cec6c052"
    sha256 cellar: :any_skip_relocation, sonoma:        "20901366b819bcbe3e3490caaee9bf32b66dcb92589ddc03774cadd544712ca8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "257a4adcbedf6d7f76e8221291ca3e516d18a1131fe64666e84aaf60e815b63f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f08788c0faea35c39648e6328f8d3507b62419f511bae16c933c67ef4d02ae7"
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
