class Etsh < Formula
  desc "Two ports of /bin/sh from V6 UNIX (circa 1975)"
  homepage "https://etsh.nl/"
  url "https://etsh.nl/src/etsh_5.4.0/etsh-5.4.0.tar.xz"
  sha256 "fd4351f50acbb34a22306996f33d391369d65a328e3650df75fb3e6ccacc8dce"
  version_scheme 1

  livecheck do
    url "https://etsh.nl/src/"
    regex(/href=.*?etsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "8d172ed230004a39a1010ea98a5d6acfcf36e611a37fadb1ec4c354edd4cb42b"
    sha256                               arm64_monterey: "3ca74ea1e75dabe8babfe8e2213e5235f7f5feab2971115379a5aa8a2d40708d"
    sha256                               arm64_big_sur:  "76d54fb29f4d0591effe6ae857882d7c6c2113db9e8dd75b4d44b106bbac84c8"
    sha256                               ventura:        "b92baad08391533553aa6234a942a101d1a66b4c0befa54ae16535af0a38442c"
    sha256                               monterey:       "59b7bfce001e37f16a637b5cab0cfafd1de1951c2bfd615285d0c17b556ae825"
    sha256                               big_sur:        "6e496f09188b22a38297bfa9f1c08d7f88278e41a76c7f407b9df17d036de751"
    sha256                               catalina:       "1bb2f2a1cdb069e4963cba22c6014894a61853644e840341e8fd01f1ca522ea2"
    sha256                               mojave:         "61739a70a6927e119b9f27fe51e24a5bd14f3c5f8cfed1888d1f00682e68c9c8"
    sha256                               high_sierra:    "dbe3c9f5881aa417660aec6e9469123dde475b33551f7207cb3cb7aaade8c16d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b63d3ead94501c6b8a1f2fd2e6cf5465e7d0f36dc1d2e1303b0ed23254141d2"
  end

  conflicts_with "omake", because: "both install `osh` binaries"
  conflicts_with "teleport", because: "both install `tsh` binaries"

  def install
    system "./configure"
    # The `tshall` target is not supported on Ubuntu 16.04 (https://etsh.nl/blog/ubuntu-16/)
    # so the `install-etshall` target must be used to only build `etshall`.
    # Check if `tshall` is supported in Ubuntu 18.04.
    install_target = OS.mac? ? "install" : "install-etshall"
    system "make", install_target, "PREFIX=#{prefix}", "SYSCONFDIR=#{etc}", "MANDIR=#{man1}"
    bin.install_symlink "etsh" => "osh"
    bin.install_symlink "tsh" => "sh6" if OS.mac?
  end

  test do
    assert_match "brew!", shell_output("#{bin}/etsh -c 'echo brew!'").strip
  end
end
