class GambitScheme < Formula
  desc "Gambit Scheme is an implementation of the Scheme Language"
  homepage "http://gambitscheme.org"
  url "https://github.com/gambit/gambit/archive/v4.9.3.tar.gz"
  sha256 "a5e4e5c66a99b6039fa7ee3741ac80f3f6c4cff47dc9e0ff1692ae73e13751ca"

  bottle do
    sha256 "2a2592928fe3f2fdf5def2c02ba9556ef54568de08ea243f559cb08b32d2c010" => :mojave
    sha256 "50cc16d8db324fe12f46a7d8b7038c859fafd60ca7e0e1d806903b267281fa1d" => :high_sierra
    sha256 "c7932e439c932992c2ca48c929b50ca2540b633155c7000ab72d1b9b143c4fac" => :sierra
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
    assert_equal "0123456789", shell_output("#{prefix}/current/bin/gsi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
