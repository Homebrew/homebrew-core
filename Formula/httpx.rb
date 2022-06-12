class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.2.2.tar.gz"
  sha256 "1e358cdd4106bb70706f9f31c584d6bcdc3b240334eb7c5dafad294baee9dc73"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b2b32168c9b5aef0ed8a27e72d2f1cabd4586b74a40e71f4a502cb789b0e2a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e39c0b080a3d53fdee619dd88956f3935a50742e363513e4c434f2d12d20753"
    sha256 cellar: :any_skip_relocation, monterey:       "714125d9f3ef91afe6b875bcbe3a6df33465a8d4226016c4839d152c5a4b610a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b2bbbd43c199b79f9e51257dc8d47bdc0c161088f9108f6782b1667d61a868c"
    sha256 cellar: :any_skip_relocation, catalina:       "00f93faf2ce86fd8a084d78382972335c1f590d8b87ff42218dbe6f1dde89105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca1884650508a9cb517d060ab0359821b7f8b10a7338f65e4f7a06aece7a5a18"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/httpx"
  end

  test do
    output = JSON.parse(pipe_output("#{bin}/httpx -silent -status-code -title -json", "example.org"))
    assert_equal 200, output["status-code"]
    assert_equal "Example Domain", output["title"]
  end
end
