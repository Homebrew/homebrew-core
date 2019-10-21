class Hspell < Formula
  desc "Free Hebrew linguistic project"
  homepage "http://hspell.ivrix.org.il/"
  url "http://hspell.ivrix.org.il/hspell-1.4.tar.gz"
  sha256 "7310f5d58740d21d6d215c1179658602ef7da97a816bc1497c8764be97aabea3"

  bottle do
    sha256 "95b64e844560f948bdd487f1aa8a36fa6b54af18a278be1793b2f34614e08736" => :catalina
    sha256 "92fac64ac02e38e225184831bda82521c4136d480660d52f599c6a92f6647860" => :mojave
    sha256 "62cf9605edbaf21775ddc788367d78260d79058fba8c90674620d1ee59c9b273" => :high_sierra
    sha256 "50be9b91b5158ce882207622b6a2581185f67a5c999c8f1105d522d800344a37" => :sierra
    sha256 "f9648fc0bbf530759a8cd7057ebed5310c3b293c5cd2c1e284aef28f55e44ba7" => :el_capitan
    sha256 "6ccb57a3f549935b58b3aaa56b0a49b5a7fc41692594d2e4a0d718a5be30fa84" => :yosemite
  end

  depends_on "autoconf" => :build

  # hspell was built for linux and compiles a .so shared library, to comply with macOS
  # standards this patch creates a .dylib instead
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/hspell/1.3.patch"
    sha256 "63cc1bc753b1062d1144dcdd959a0a8f712b8872dce89e54ddff2d24f2ca2065"
  end

  def install
    ENV.deparallelize

    # autoconf needs to pick up on the patched configure.in and create a new ./configure
    # script
    system "autoconf"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "--enable-linginfo"
    system "make", "dolinginfo"
    system "make", "install"
  end

  test do
    File.open("test.txt", "w:ISO8859-8") do |f|
      f.write "שלום"
    end
    system "#{bin}/hspell", "-l", "test.txt"
  end
end
