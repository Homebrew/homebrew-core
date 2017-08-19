class Datamash < Formula
  desc "Tool to perform numerical, textual & statistical operations"
  homepage "https://www.gnu.org/software/datamash"
  url "https://ftpmirror.gnu.org/datamash/datamash-1.1.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/datamash/datamash-1.1.1.tar.gz"
  sha256 "420819b3d7372ee3ce704add847cff7d08c4f8176c1d48735d4a632410bb801b"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b0e4f5e26b38b4db687a3e9eaeb103ef580461a40ddbc31af1eaf0758d54efa" => :sierra
    sha256 "296cf7d1f291f1ffb0f6f877d1d1a7724877195f0a53e7abdeb7b91389742757" => :el_capitan
    sha256 "734d31b032f5dc7ed2968c20d04938f9b028ed3e3b9587efc548bdfba2d589ce" => :yosemite
  end

  head do
    url "git://git.savannah.gnu.org/datamash.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "55", shell_output("seq 10 | #{bin}/datamash sum 1").chomp
  end
end
