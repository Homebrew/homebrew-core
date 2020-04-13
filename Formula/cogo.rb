class Cogo < Formula
  desc "An easy CLI tool to interact with multiple different cloud providers"
  homepage "https://cogoapp.dev"
  url "https://github.com/Midnight-Conqueror/cogo/archive/2.2.3.tar.gz"
  sha256 "9603d7bbe59a2e3e4eda0a6a3137299280675b6d0a6a43a0e68850c38f2a7921"

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "./bin/cogo" => "cogo"
  end

  test do
    system bin/"cogo", "version"
  end
end
