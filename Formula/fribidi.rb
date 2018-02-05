class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://github.com/fribidi/fribidi/releases/download/v1.0.1/fribidi-1.0.1.tar.bz2"
  sha256 "c1b182d70590b6cdb5545bab8149de33b966800f27f2d9365c68917ed5a174e4"

  bottle do
    cellar :any
    sha256 "a4cf0ea06a675c060d157264a85dcb0c378b3b6cb048d529a4c9295b62defae3" => :high_sierra
    sha256 "d94bcc9e376dc22b291bbb62824dcf1669dd14c0653ef49d98e6458be83e6a99" => :sierra
    sha256 "705fdec56849cae873d504d6925209cfc4c7802d10de0f48022845b6bec5e8ce" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "pcre"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--with-glib", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.input").write <<~EOS
      a _lsimple _RteST_o th_oat
    EOS

    assert_match /a simple TSet that/, shell_output("#{bin}/fribidi --charset=CapRTL --test test.input")
  end
end
