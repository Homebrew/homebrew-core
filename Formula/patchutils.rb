class Patchutils < Formula
  desc "Small collection of programs that operate on patch files"
  homepage "http://cyberelk.net/tim/software/patchutils/"
  url "http://cyberelk.net/tim/data/patchutils/stable/patchutils-0.3.4.tar.xz"
  mirror "https://deb.debian.org/debian/pool/main/p/patchutils/patchutils_0.3.4.orig.tar.xz"
  sha256 "cf55d4db83ead41188f5b6be16f60f6b76a87d5db1c42f5459d596e81dabe876"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8bb5cb6b431a18e81e68fbe6e2657420ceb9a53cd71d0f88d82f5094cca32c04" => :catalina
    sha256 "50671cd67bc54857e9ba8b80f340ad14445ce9af6219dc28a50fb66fb85a9be6" => :mojave
    sha256 "3b9acf217323af3cfceda6499aff6bf31086a301533effebe831757a625721f5" => :high_sierra
    sha256 "948da3692c5f55995ea83303063cc0a9f01387c220f262365ef0e8cc775e8a39" => :sierra
    sha256 "08689727cdf1f89cc075ec2e6e71ac456c5429067899ccb5dac12848a6c2abcd" => :el_capitan
    sha256 "df5a0b90219fe01b6934696d27782920c3e9c45152980e72a1c542006c625ae9" => :yosemite
    sha256 "84cae8e92f1e9b3f377fd6584c0811a3c3989fb898bb7596ba0d1192ae10a834" => :mavericks
  end

  head do
    url "https://github.com/twaugh/patchutils.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "docbook" => :build
  end

  depends_on "xmlto" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog" if build.head?
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match %r{a\/libexec\/NOOP}, shell_output("#{bin}/lsdiff #{test_fixtures("test.diff")}")
  end
end
