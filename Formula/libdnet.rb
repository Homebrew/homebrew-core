class Libdnet < Formula
  desc "Portable low-level networking library"
  homepage "https://github.com/dugsong/libdnet"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libdnet/libdnet-1.12.tgz"
  sha256 "83b33039787cf99990e977cef7f18a5d5e7aaffc4505548a83d31bd3515eb026"

  bottle do
    cellar :any
    rebuild 3
    sha256 "5b9ce1110f17d6191bbb917e7bcecca734fc741d3534e67a10326314e15ecccb" => :mojave
    sha256 "a9747616e12b57f7d3bd14e070d2054c2f3bfd836be6328005b964ccbe85a3f9" => :high_sierra
    sha256 "c9c71fab92a207e7a9bceef1d4102a545c36c5f23aae9d4774d46de4c8b22890" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # autoreconf to get '.dylib' extension on shared lib
    ENV.append_path "ACLOCAL_PATH", "config"
    system "autoreconf", "-ivf"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/dnet-config", "--version"
  end
end
