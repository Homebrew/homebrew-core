class Libbson < Formula
  desc "BSON utility library"
  homepage "https://github.com/mongodb/libbson"
  url "https://github.com/mongodb/libbson/releases/download/1.5.0/libbson-1.5.0.tar.gz"
  sha256 "ba49eeebedfc1e403d20abb080f3a67201b799a05f4a012eee94139ad54a6e6f"

  bottle do
    cellar :any
    sha256 "1163f5b71bd4c0131fc5bde5cbe6bc43265822b0d6dc9cc39b0a71b1bf758a73" => :sierra
    sha256 "de0b934fbd4a6e92aa270d99a51263926164493450771a7f4997f4f46bd8b785" => :el_capitan
    sha256 "29cbab0c40ba25666c757b9e920fd1bbbfbae1867468d37bf33119a512ae3764" => :yosemite
  end

  def install
    system "./configure", "--enable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
