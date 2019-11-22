class GambitScheme < Formula
  desc "Gambit Scheme is an implementation of the Scheme Language"
  homepage "https://github.com/gambit/gambit"
  url "https://github.com/gambit/gambit/archive/v4.9.3.tar.gz"
  sha256 "a5e4e5c66a99b6039fa7ee3741ac80f3f6c4cff47dc9e0ff1692ae73e13751ca"
  revision 1

  bottle do
    sha256 "5e10d73020823bad8ca4b5aec00391fcd06d200756084ddd86ecaf12082608be" => :mojave
    sha256 "397dc40ff05f988c80c438c804ad344ad8033eef845c3f36f50b5cb3d67178f9" => :high_sierra
    sha256 "cca0083994c00b4d8199330c6292359e7361eec9def7e6c3fcb0a0dd4d155acf" => :sierra
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
