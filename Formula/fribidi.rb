class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://github.com/fribidi/fribidi/releases/download/v1.0.10/fribidi-1.0.10.tar.xz"
  sha256 "7f1c687c7831499bcacae5e8675945a39bacbad16ecaa945e9454a32df653c01"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "3a430c4eeb948c10595ffe163455f214f251bdb901f5846a0b67eb4f8aafdc71"
    sha256 cellar: :any,                 big_sur:       "edc35b607a4be54edba895c367f4f7df356d863fd9abaf34323206ac46fe5655"
    sha256 cellar: :any,                 catalina:      "c3799c193fb513a5c66a6e9fa950c1bdd15c12f931b9421dbf8e1c8e994f41e3"
    sha256 cellar: :any,                 mojave:        "a53aef8adec171a839a2ea0f7d90655f385215d4a6c45c0ffc2a97c75a297fb5"
    sha256 cellar: :any,                 high_sierra:   "83253b57bd1621e9340bfdb86ba147ff0a095e006ef53ad0c5421107557475a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5401d916ef3e014f60e9273549790a6946901ada7ecf71b37cf19802819732ee"
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

    assert_match "a simple TSet that", shell_output("#{bin}/fribidi --charset=CapRTL --test test.input")
  end
end
