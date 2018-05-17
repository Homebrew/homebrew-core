class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://github.com/fribidi/fribidi/releases/download/v1.0.3/fribidi-1.0.3.tar.bz2"
  sha256 "8d214b17b6eedcb416e53142c196c2896b9a685fca2a5bddc098a73d2b02ce12"

  bottle do
    cellar :any
    sha256 "ea9de1088c192b2b816f82c926a791230a84a639007a44c021c51a11450770a2" => :high_sierra
    sha256 "8aa317d486213f13d0fc1640eac5ec24c13e7e581a3a17c0877051bda2027d7c" => :sierra
    sha256 "e7a9240ac6445d07f4fb337ce2d4df8beaa8c0d51e4e0a735678dfd3a76ce35b" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"
  end

  test do
    (testpath/"test.input").write <<~EOS
      a _lsimple _RteST_o th_oat
    EOS

    assert_match /a simple TSet that/, shell_output("#{bin}/fribidi --charset=CapRTL --test test.input")
  end
end
