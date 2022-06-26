class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2022.04/MoarVM-2022.04.tar.gz"
  sha256 "ae06f50ba5562721a4e5eb6457e2fea2d07eda63e2abaa8c939c9daf70774804"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "b039b7f3e5479b8c7edeacc49862aa3082fde0d7a85096fbe268fcdd1c129523"
    sha256 arm64_big_sur:  "17f35bc7a45dc7379d4cfeb147a7313b3fe9d449135b91d66e0fce468e4ea7a4"
    sha256 monterey:       "c504b1d2432155dbd1b255d8d4dc2f4658611f90b06397ad836444effbedb80d"
    sha256 big_sur:        "53431ea6fc2bc6a331eda5c7cf190e3b61d3eaf3f538889d41aed51f481db8cf"
    sha256 catalina:       "957ef92208468bd4d35c9929867114c7c33db690d6b2ff0b60b7e7ef9e0c436e"
    sha256 x86_64_linux:   "31176bc8f79104414cf58f283923a98016a1c045f69ba2ab79c8cea3ba7cc77c"
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  uses_from_macos "perl" => :build

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2022.04/nqp-2022.04.tar.gz"
    sha256 "556d458e25d3c0464af9f04ea3e92bbde10046066b329188a88663943bd4e79c"
  end

  def install
    configure_args = %W[
      --c11-atomics
      --has-libffi
      --has-libtommath
      --has-libuv
      --optimize
      --pkgconfig=#{Formula["pkg-config"].opt_bin}/pkg-config
      --prefix=#{prefix}
    ]
    system "perl", "Configure.pl", *configure_args
    system "make", "realclean"
    system "make"
    system "make", "install"
  end

  test do
    testpath.install resource("nqp")
    out = Dir.chdir("src/vm/moar/stage0") do
      shell_output("#{bin}/moar nqp.moarvm -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    end
    assert_equal "0123456789", out
  end
end
