class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.4.6/libatomic_ops-7.4.6.tar.gz"
  sha256 "96e88ba450ae5fa10aa8e94e6b151a63ffbe47f8069574bd12da22ae80c686db"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc80848a3579f5de3f041b1cfb59ac94844555367f6eaf17628d177bd587d780" => :sierra
    sha256 "912aa8d5209d8404722163995bc40b4d5ee14772f2bdd8f7da925cbd5958cbb1" => :el_capitan
    sha256 "319892011eb1e30819c7a0bfad69677f1b53c6522248350610bbff6b4063b2a6" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
