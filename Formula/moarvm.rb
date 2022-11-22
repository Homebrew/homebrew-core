class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2022.07/MoarVM-2022.07.tar.gz"
  sha256 "337ef04d16f826f99465c653b92006028fe220be68d3dcfd0729612f4f6b5b46"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "5a0e24b677f599e65ab76c68536af693985bf4fce971283f748fd136353715e2"
    sha256 arm64_monterey: "c335ea6fcf6d368da8cd089eef6d4e92f1afacc0b3611c3998962a30e11ef541"
    sha256 arm64_big_sur:  "136c4fa195d271d6173d7cedce64687469d78f98abdb54e63ad0867b509aeee1"
    sha256 ventura:        "79f919e3dfa490ec1b710e8594d6c4007e0c68e867cb3725cb0c4396bf5dfd89"
    sha256 monterey:       "9701ad19168d40f5bc1f8dd8be949a8dedce92aa126ea2ec94610910cddeac8f"
    sha256 big_sur:        "2a620be5f33a4905533b3c72e3cf89362539ce7afe73d9df8980c7546ede3346"
    sha256 catalina:       "9e0bb460a56d78c2b92a9cd4a5c5bccab43a50cee9cb6edc32777edf4177f741"
    sha256 x86_64_linux:   "0e0a0f4df22ec7905fe04088cb0f1544c889f3c7146ebe76d54d14808cbd18cf"
  end

  depends_on "pkg-config" => :build
  depends_on "libtommath"
  depends_on "libuv"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2022.07/nqp-2022.07.tar.gz"
    sha256 "58081c106d672a5406018fd69912c8d485fd12bf225951325c50c929a8232268"
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
