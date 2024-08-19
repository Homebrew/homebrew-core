class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2024.07/MoarVM-2024.07.tar.gz"
  sha256 "625241fe1578341f6099784f0ea82a62b8a638855c3b8fa604d6ce9e5024fe29"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "4c6554bdc32cd98e00871bee60e427c773a0de141308b27ae2282397aa06857d"
    sha256 arm64_ventura:  "8a8d69cdd896206c17b064f046323b454b9a2d7ab81b88d065b3437ab1a77389"
    sha256 arm64_monterey: "624e25cb64bf307167daae1cc1e1d13fdda590a334d346e198346513967ce7d6"
    sha256 sonoma:         "f4b3e450cd22a28d9d3739d505c6fd2fc21cb3b02b71184c057f4359ab05e965"
    sha256 ventura:        "bc305ba6beb7e85e4c8ea66565486c5245331745260c24db6642b5d96974b298"
    sha256 monterey:       "e44a7877ecc17bed11f6684887c1cb5616254180df1029a8fdf763d70c6fe6f5"
    sha256 x86_64_linux:   "c6950e5f56ccf31ce51d30b3e1639f040fe9d193d0c26d833d154b6f034d6b97"
  end

  depends_on "pkg-config" => :build
  depends_on "libtommath"
  depends_on "libuv"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "moar", because: "both install `moar` binaries"
  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2024.07/nqp-2024.07.tar.gz"
    sha256 "ab13f2de962817bfedc971088aa6b54911c424150dc284623444ef64878af07e"
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
