class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.4.6/libatomic_ops-7.4.6.tar.gz"
  sha256 "96e88ba450ae5fa10aa8e94e6b151a63ffbe47f8069574bd12da22ae80c686db"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f1ae1dd838e499bca0fafb07339b3fc742cdea3341760ecaece9b42d8e919f3" => :sierra
    sha256 "2ca5c62c613dd85ac4901f9e937a901b19048f9e691c8f91961099dcf0ce08a9" => :el_capitan
    sha256 "7ef7eb4cccf81644068a38b67f1ad191d100b29130f9561f3d676b3c651a7566" => :yosemite
    sha256 "df26486b811bd7c6fe6a18622c4716e2e106b9726a8887a9bca69c4f7bc8b56a" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
