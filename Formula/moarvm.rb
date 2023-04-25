class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2023.04/MoarVM-2023.04.tar.gz"
  sha256 "8e83e894a3e04a213adb340552520f30181d4d280c77a576b5c1ee2214a03364"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "affe4e7a3bb56e5d3f364b44937f4d6909188ee0866b4fcf4961882b8caea577"
    sha256 arm64_monterey: "ea66d469fa62b2d44d00e59b68a506887d330de9953df22358e49e19a985dda9"
    sha256 arm64_big_sur:  "4dd6d37bc64321dcac4c363072fc9f90ea83ad6c864108d20915a922d6d9d9c5"
    sha256 ventura:        "9691e18940b7ebac50254897457f34a624c4f09003aedeb334148e6cf4711feb"
    sha256 monterey:       "52fd840b6b3ce8c587955adbc3c92703ba612807d9bcbe8a505cbe5029503029"
    sha256 big_sur:        "2beb85eb150999eb40ca2aba830dbfeaa842093fcb9d50157a87f569b665e3d6"
    sha256 x86_64_linux:   "15030842248e39212b4f1e4464b01e1599ccaed2a5f9f482204744eefd8cf5a2"
  end

  depends_on "pkg-config" => :build
  depends_on "libtommath"
  depends_on "libuv"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2023.02/nqp-2023.02.tar.gz"
    sha256 "e35ed5ed94ec32a6d730ee815bf85c5fcf88a867fac6566368c1ad49fe63b53f"
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
