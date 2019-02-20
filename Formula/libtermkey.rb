class Libtermkey < Formula
  desc "Library for processing keyboard entry from the terminal"
  homepage "http://www.leonerd.org.uk/code/libtermkey/"
  url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.21.1.tar.gz"
  sha256 "cecbf737f35d18f433c8d7864f63c0f878af41f8bd0255a3ebb16010dc044d5f"

  bottle do
    cellar :any
    sha256 "945900f29b87c2a1b56ba2f5173a24e18a69e5fb89a0e98d24d9b1a6005ec8c8" => :mojave
    sha256 "86b77ba58bcc60113c50524a8469df423f1797dc76c86ca545263a5af54cf7a6" => :high_sierra
    sha256 "1d9be250f24a65c1a324a6409ff913792b2a830d253c0e5cf4a5671f614c2169" => :sierra
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
