class Posh < Formula
  desc "Policy-compliant ordinary shell"
  homepage "https://salsa.debian.org/clint/posh"
  url "https://salsa.debian.org/clint/posh/repository/debian/0.13.2/archive.tar.gz"
  sha256 "d4ea1e08b4e2916a6a43f50f7892ab4152e9438b19f7a008e5b2a46e4f5ac774"

  bottle do
    cellar :any_skip_relocation
    sha256 "700e48f30128fa0fdd35c3117154dd24455ba2a8839bd56fda146f5cf8e4eb11" => :mojave
    sha256 "9c38d14973e3fd33480cfdb45442a1e2e5291d4a60008ea61c689d497f8ff7ef" => :high_sierra
    sha256 "d8528d6120edc6a45b43c7e3b148b5cb8859dcd10ee24c60ae7b1c7cfaa992d5" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/posh -c 'echo homebrew'")
    assert_equal "homebrew", output.chomp
  end
end
