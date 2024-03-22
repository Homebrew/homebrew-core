class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2024.02/MoarVM-2024.02.tar.gz"
  sha256 "834d3eafb56ab78ee53084c24c23772527e7e16267cf697e5cf8e32cebbfbd2a"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "6bb36eb66ea6a36dbd184c99ab98f048307ef92c35201bee6731bbe82bb6256f"
    sha256 arm64_ventura:  "034b2ac16b88ec73db132d06dfa190b2cfbe539b10fce2ff986781f0754b3e86"
    sha256 arm64_monterey: "66cd1004d350f839a1f7ca4c23692778676837a6aa9fa0994399bedbc73ed5de"
    sha256 sonoma:         "2a9ea35810b80540c09d4f89505f71ed8966d1b52353ea47b83cce4fb48b73fd"
    sha256 ventura:        "2a38d7c1be98e5c0b1c5cb2b94b409db894ce446de7acb4dc00ce66dfa70e660"
    sha256 monterey:       "c7593ac596c73f9de993f8ad451de638edbe14718205d3e1d192b3848f914a39"
    sha256 x86_64_linux:   "40fa644a86901f6b4e31775f3150ad89b931b98d4a114f42ca11905671f53a22"
  end

  depends_on "pkg-config" => :build
  depends_on "libtommath"
  depends_on "libuv"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2024.02/nqp-2024.02.tar.gz"
    sha256 "a75c44099e69e1e623302be6f8edde3116d12aa370c6f502f0b9fc65ebf63fcf"
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
