class GambitScheme < Formula
  desc "Gambit Scheme is an implementation of the Scheme Language"
  homepage "https://github.com/gambit/gambit"
  url "https://github.com/gambit/gambit/archive/v4.9.3.tar.gz"
  sha256 "a5e4e5c66a99b6039fa7ee3741ac80f3f6c4cff47dc9e0ff1692ae73e13751ca"
  revision 1

  bottle do
    rebuild 1
    sha256 "a8b9f1adce4260059b05505e13fd9036a9bdb689aa8e7a56ef8d0804199988b0" => :mojave
    sha256 "8626389fe8f07074733a80f85d6da64b5961258f7f5a6c8258427a5378842f01" => :high_sierra
    sha256 "e0f5ba1f66edf7b2639280d1e954b43cd539e5501b8c69b543993c85e3f9db90" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-single-host
      --enable-multiple-versions
      --enable-default-runtime-options=f8,-8,t8
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
