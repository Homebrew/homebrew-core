class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-2.8.4.tar.gz"
  sha256 "5823ccd0c18fe10a368a117cc3924748c4a5d0fe8dff0d9d818ff73c342565f0"

  bottle do
    sha256 "888a4d7dfa4d9379d09657fe3ff4d673238c9827dfbe443f8cacbd40a32c042e" => :sierra
    sha256 "78c7f1fea5c16a6c7e8d774bbd91174bb541a9548766a70c2da3660f73c8a01c" => :el_capitan
    sha256 "8b635fbd56159120fef7b0dca5364de8baa2b7d9a2f87956b86d31e4dd51a111" => :yosemite
  end

  depends_on "gsl" => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<-EOS.undent
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
