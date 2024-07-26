class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v1.20.4.tar.gz"
  sha256 "7b29114eefbe0b0c8727cef476c6729b4e5ed246e6f60d2a14119947f7ee5f34"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gollama -v")
    assert_match "Search results for: test", shell_output("#{bin}/gollama -s test")
  end
end
