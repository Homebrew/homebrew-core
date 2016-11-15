class Mpop < Formula
  desc "POP3 client"
  homepage "http://mpop.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mpop/mpop/1.2.6/mpop-1.2.6.tar.xz"
  sha256 "9fec7a9dd08fc0f04bf6178bc651b036d1fe0e46903146f38a8d182887e9315c"

  bottle do
    cellar :any
    sha256 "2d03238722efe5532d69ef80bf86e700664f1d6cadbc3ff4c2a1b4ac203fef3c" => :sierra
    sha256 "6aaf347d5917c4366b7572ff6ac48e5cf7be653a1dc34347503f64c6d5b38d4d" => :el_capitan
    sha256 "55de4c36ac34e22563d5adf327a50e9859e7ba6a848254d3f9f226791086bf72" => :yosemite
    sha256 "6152acd7293ead40fce85a67e9e451d15ddfa71775e688e08aef11d9565005ae" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end
