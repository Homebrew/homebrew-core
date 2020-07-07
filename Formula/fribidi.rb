class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://github.com/fribidi/fribidi/releases/download/v1.0.10/fribidi-1.0.10.tar.xz"
  sha256 "7f1c687c7831499bcacae5e8675945a39bacbad16ecaa945e9454a32df653c01"
  license "LGPL-2.1"

  bottle do
    cellar :any
    sha256 "4064e6326b3ba81ba14ce6287231143295de208b47f448e9dc73c21a9c4ce513" => :catalina
    sha256 "ff1dc0448d33b1313bbc88915ed7fc21d15cda4991713d778ce72983bdd85335" => :mojave
    sha256 "3bf7f77c99b0c225610be974ccb3a3a1d364914eba7ced0ba450584e543a621c" => :high_sierra
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
