class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://github.com/gdraheim/zziplib"
  url "https://github.com/gdraheim/zziplib/archive/v0.13.69.tar.gz"
  sha256 "846246d7cdeee405d8d21e2922c6e97f55f24ecbe3b6dcf5778073a88f120544"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2e293f90e2ebee0734ff9bb6a23cdcd562383d87e801de996f57296aef3a15b4" => :mojave
    sha256 "7ae8222e9b3f3d56639d19de2666eb1dffb6399d5985a64f52a24cdbe3763b58" => :high_sierra
    sha256 "72c6927e722159e240f313b0bbc5dfd7648b340fd7a9c732d99e9eeaac6d4945" => :sierra
    sha256 "2ed4dd48a0e3ae9b528164456652b0d5e8730153c398b6441a1ffb7d44e45f4d" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = %W[
      --without-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"README.txt").write("Hello World!")
    system "/usr/bin/zip", "test.zip", "README.txt"
    assert_equal "Hello World!", shell_output("#{bin}/zzcat test/README.txt")
  end
end
