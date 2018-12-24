class GambitScheme < Formula
  desc "Gambit Scheme is an implementation of the Scheme Language"
  homepage "http://gambitscheme.org"
  url "https://github.com/gambit/gambit/archive/v4.9.1.tar.gz"
  sha256 "667ae2ee657c22621a60b3eda6e242224d41853adb841e6ff9bc779f19921c18"

  bottle do
    sha256 "61c261221bd5f04afff4c3c5a88d0dd34674f58052c6a958f97179cd060a46cd" => :mojave
    sha256 "667d14dc806cccc5170dbba686dea5b8042fe940edd372696296d06e3ba88b52" => :high_sierra
    sha256 "8b77b5315032fce450b7e6b39e05533817fdb9995351f083f358a1ec1e5f6e06" => :sierra
  end

  depends_on "openssl"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-single-host
      --enable-multiple-versions
      --enable-default-runtime-options=f8,-8,t8
      --enable-poll
      --enable-openssl
    ]

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_equal "0123456789", shell_output("#{prefix}/v4.9.1/bin/gsi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
