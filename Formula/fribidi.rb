class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://github.com/fribidi/fribidi/releases/download/v1.0.10/fribidi-1.0.10.tar.xz"
  sha256 "7f1c687c7831499bcacae5e8675945a39bacbad16ecaa945e9454a32df653c01"
  license "LGPL-2.1"

  bottle do
    cellar :any
    sha256 "c3799c193fb513a5c66a6e9fa950c1bdd15c12f931b9421dbf8e1c8e994f41e3" => :catalina
    sha256 "a53aef8adec171a839a2ea0f7d90655f385215d4a6c45c0ffc2a97c75a297fb5" => :mojave
    sha256 "83253b57bd1621e9340bfdb86ba147ff0a095e006ef53ad0c5421107557475a0" => :high_sierra
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
