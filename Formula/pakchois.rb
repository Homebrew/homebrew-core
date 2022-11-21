class Pakchois < Formula
  desc "PKCS #11 wrapper library"
  homepage "http://www.manyfish.co.uk/pakchois/"
  url "http://www.manyfish.co.uk/pakchois/pakchois-0.4.tar.gz"
  sha256 "d73dc5f235fe98e4d1e8c904f40df1cf8af93204769b97dbb7ef7a4b5b958b9a"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?pakchois[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 3
    sha256                               arm64_ventura:  "d8467830fd424d6fea0a0f0ff82949262d55d4221fa2a2d630b0679d374c803f"
    sha256                               arm64_monterey: "fb701bf9c363b4e09f285fa9c6f60aba921a93f826c37afd5fcc54b0bc5e4ed1"
    sha256 cellar: :any,                 arm64_big_sur:  "86e77a851ff2c0de31cf5e4f2587711b7b1bcc742fb878df1ce69fde836fd864"
    sha256                               ventura:        "b6a9c3707dd02ec65d927974bd8534be159b2dd977f14df74907eadb0165e953"
    sha256                               monterey:       "f53bdb6cb2f47b0ed2e1df5f2c80f9568c3b2c55463de2cfdfe742da945364c0"
    sha256 cellar: :any,                 big_sur:        "fd91b09bb010ac37483a910b0431c6082903ee843a15f4cc767bde57ce0b7267"
    sha256 cellar: :any,                 catalina:       "ca82f2950582bc54e46122eb71ff8e8acdc739772baf53ab2d545755f03303f8"
    sha256 cellar: :any,                 mojave:         "cc98c7b706f27320ee7c673d906b4da22b402afe0d93b4c66f73a8cde86f7929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9e96d8cef014042091db67065c8b02439cba4cfd381ca7651bc721ec120ad4a"
  end

  def install
    # Fix flat namespace usage
    inreplace "configure", "${wl}-flat_namespace ${wl}-undefined ${wl}suppress", "${wl}-undefined ${wl}dynamic_lookup"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
