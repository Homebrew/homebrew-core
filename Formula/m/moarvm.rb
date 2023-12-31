class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2023.12/MoarVM-2023.12.tar.gz"
  sha256 "08095605dd2b6a0ebb01394395a725ae561d655700835fa2eff90122a9b1d22a"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "b58f3fbe530e0675f703a52cfd90077c6e97104447f0c3c1849f9210ec43b760"
    sha256 arm64_ventura:  "b51c915b2206066c38ad984619e9dd416f05ba480ddde8635ad1d95cbaacc970"
    sha256 arm64_monterey: "dd605a15d6b4b9f66362ab282356f1d51aa88778a2eb55c1166daf7d27b257b9"
    sha256 sonoma:         "e26d23d5fe82b00d84db1d669d23efffc5c0d7305097805ee02da55f478eeb53"
    sha256 ventura:        "589e8be6efec3d6a0cc15254d2ddc57aedbf9d111cd6ffde809100d70946052f"
    sha256 monterey:       "530b4e62a331dcae4b00e2ddfb0274b2ae85aa309a7d1bc4e41c210ccfe38a10"
    sha256 x86_64_linux:   "a15f3a85ba006d759e037fd1fd7c92c353c99b50d60175f4b01b6d57b8ef2c61"
  end

  depends_on "pkg-config" => :build
  depends_on "libtommath"
  depends_on "libuv"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2023.11/nqp-2023.11.tar.gz"
    sha256 "e7176b1a6fbaa98c132e385f325c6211ff9f93c0a3f0a23ceb6ffe823747b297"
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
