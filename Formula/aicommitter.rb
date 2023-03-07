class Aicommitter < Formula
  desc "Your AI assistant that can help you write your commit message"
  homepage "https://github.com/jiak94/aicommitter"
  url "https://github.com/jiak94/aicommitter/archive/refs/tags/1.0.0.tar.gz"
  sha256 "08c6e0843dc75bc1d902a3c99b9324d3200e31c468fc55dbd7e82a4c90f15efa"
  license "MIT"

  depends_on "go" => :build
  def install
    system "go", "build", "-v", "-o", "aicommit"
    bin.install "aicommit"
  end

  test do
    system "#{bin}/aicommit", "--version"
  end
end
