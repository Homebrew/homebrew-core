class Lzlib < Formula
  desc "Data compression library"
  homepage "http://www.nongnu.org/lzip/lzlib.html"
  url "http://download.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.8.tar.gz"
  sha256 "41bfa82c6ee184ed0884437dc4074ad505e64cb747432cefa97976b89045cbad"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1ee23db1e2ac1cfb5386808b42552f6d4e32c15cca856101f7fdaf08c2f3243" => :el_capitan
    sha256 "6b849a8bee4d6c2d93e81c3a8397ef627533e29a2804509b3e6f0a5ce53c7447" => :yosemite
    sha256 "15c49172418dcadf8d5d507a63cd30823b8c2c688da6b7f40ce0d212c9946838" => :mavericks
    sha256 "48d3952ffe00f886b514a07f241a8a94f8950b977e032f1cf52600db4c09eb76" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CC=#{ENV.cc}",
                          "CFLAGS=#{ENV.cflags}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
