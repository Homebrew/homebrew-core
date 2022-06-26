class Mspdebug < Formula
  desc "Debugger for use with MSP430 MCUs"
  homepage "https://dlbeer.co.nz/mspdebug/"
  url "https://github.com/dlbeer/mspdebug/archive/v0.25.tar.gz"
  sha256 "347b5ae5d0ab0cddb54363b72abe482f9f5d6aedb8f230048de0ded28b7d1503"
  license "GPL-2.0"
  head "https://github.com/dlbeer/mspdebug.git"

  bottle do
    sha256                               arm64_monterey: "42af25df066a3e948b0644670299949b54582bdede0ab53e41dcb346c0c2c92e"
    sha256                               arm64_big_sur:  "2c4c83e755286f97432ced3adb0e81a15e2241715e82135a6cc758999d621cfd"
    sha256                               monterey:       "161469d0a1065aa833dede6bb5b10f2caebecb397ea5af306ee64b4d8c71f937"
    sha256                               big_sur:        "bd15ded651cbe43d819ae5f6a52d90cfafd51306d42a2f2b6c98d1b70ed4873f"
    sha256                               catalina:       "4e512b296b8a655fbe8632afca020866f6499c461fb715aef5c4eb6bdda88034"
    sha256                               mojave:         "4d5d8c35966a0000b010bbaea7c2c403ff4921d1306d34d752ccceb3f3d3b155"
    sha256                               high_sierra:    "4124d4fbd9e191d941153962bb74aed50cc200c473b5ad5850610a1bc85f87b4"
    sha256                               sierra:         "e16447e04c99d74b8cdc49a063c230c64d09e34402d0221542594f3aacac5940"
    sha256                               el_capitan:     "22fc92bc5a594451eb0d0b943bce812619302c795fdad0ca4305c059ccf10a88"
    sha256                               yosemite:       "8b23c23287fc9ab143921257a1859f8ac0dbb9e093261dfe931ec7d6a3548d97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "591e9d4d6bf5cedceda3db088a416b6c597acdcd65d40856c8f5fd69c49b8c7c"
  end

  depends_on "hidapi"
  depends_on "libusb-compat"

  def install
    ENV.append_to_cflags "-I#{Formula["hidapi"].opt_include}/hidapi"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats
    <<~EOS
      You may need to install a kernel extension if you're having trouble with
      RF2500-like devices such as the TI Launchpad:
        https://dlbeer.co.nz/mspdebug/faq.html#rf2500_osx
    EOS
  end

  test do
    system bin/"mspdebug", "--help"
  end
end
