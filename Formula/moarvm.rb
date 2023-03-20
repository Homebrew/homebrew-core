class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2023.02/MoarVM-2023.02.tar.gz"
  sha256 "67e214d44d5f626787ca7f04424043a639308a43a7777b6fa41926b7240e0dc5"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "25ef89f366c23e4ee1466e54b833699756210957d599d124f8bdb8f941d221a2"
    sha256 arm64_monterey: "810a8b90e384ebafc3129c442fc8011ff15bfbc8a402ee112f1234be7fe971cd"
    sha256 arm64_big_sur:  "1f48684d345d051d79e5e8077d055ec0349517aed2a22e43bc0e7b02355b2184"
    sha256 ventura:        "d5e27c13c55d2a0b6cd8aeb2679f61aef40f7bd5257621d60b601710b85778b7"
    sha256 monterey:       "f8e2a42f8d00a8abc07d80dc844d8ed09fdbe6f1f186c3b8ec3fdb3d25fbdd6d"
    sha256 big_sur:        "3c002e9a027d4b8b585243e4217d23d96bf7e0d27d503780fa6a57196b684afa"
    sha256 x86_64_linux:   "52b1fbdd24828845cc4ffbe62a230f8479d3df49c1e996ba742a9a1177440ff3"
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
