class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20180525.tgz"
  sha256 "129b8d8be35c2cecb89e4ef434dc512402c0243f485334c5733ddf1e267c2de6"

  bottle do
    cellar :any_skip_relocation
    sha256 "24b76c770a8ad4bc95c87a7429dca550803f72d8c78bb72017a0732cc1e675a3" => :high_sierra
    sha256 "82f7e36647c1161ebc189c82ccca0416eaced470ae61ce9da5ac2aff84720f3c" => :sierra
    sha256 "9b5bbfdae8bba9f981d1586ce618a6c5ea9726006c75df0b7a9a68c3d9a6e757" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
