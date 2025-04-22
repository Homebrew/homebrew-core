class Bfgminer < Formula
  desc "Modular CPU/GPU/ASIC/FPGA miner written in C"
  homepage "https://web.archive.org/web/20221230131107/http://bfgminer.org/"
  url "https://web.archive.org/web/20190824104403/http://bfgminer.org/files/latest/bfgminer-5.5.0.txz"
  sha256 "ac254da9a40db375cb25cacdd2f84f95ffd7f442e31d2b9a7f357a48d32cc681"
  license "GPL-3.0-or-later"
  head "https://github.com/luke-jr/bfgminer.git", branch: "bfgminer"

  bottle do
    sha256 arm64_sonoma:   "e3d88bfc64abc6a6e41f8d96d5d6b099b7c93c5829f17f1ec134a3b0e0aad44d"
    sha256 arm64_ventura:  "b45669226e0d2a3155e437d643ef700ff143ce071dd3c4affce7a80ef24ab568"
    sha256 arm64_monterey: "2179e3de8ffd1c871a9b3a7fa539e569d62ba42b67d0c12ed609098cb9214e6d"
    sha256 arm64_big_sur:  "f397c2b4428a3c96239d86edf75efb444ba7b1cc79f6d2550ba04960e40308e2"
    sha256 sonoma:         "dd8db416717d33317ea08df28bf38dc497bef8044161067a44ffa16d32df254a"
    sha256 ventura:        "90867fc9aba1b6844de5403e3e3bc71a01b01686c28b06e574759c44d541ed06"
    sha256 monterey:       "5548f25bdbecdca56951bcc0d0d44b5fc509bb86c525c02c64599fd826928eab"
    sha256 big_sur:        "0ae6dafd587a2dd9d20d57b34d96ddcea07d570c251db4d0b9e4397ebd6ca0ec"
    sha256 catalina:       "c0a7446badb4b9c392d616a73e48035632a28f4f34adb45052ab022b6856d9ec"
    sha256 x86_64_linux:   "9f81c9ed9c2d32a0296fb74aa46b592b02e60fc08224d103c9c6ba73bedff86b"
  end

  # Upstream website is gone, cannot build from GitHub source, last release 6+ years ago
  disable! date: "2024-09-05", because: :unmaintained

  depends_on "hidapi" => :build
  depends_on "libgcrypt" => :build
  depends_on "libscrypt" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "uthash" => :build
  depends_on "jansson"
  depends_on "libevent"
  depends_on "libusb"
  uses_from_macos "curl"

  def install
    args = %w[
      --without-system-libbase58
      --enable-cpumining
      --enable-opencl
      --enable-scrypt
      --enable-keccak
      --enable-bitmain
      --enable-alchemist
    ]
    args << "--with-udevrulesdir=#{lib}/udev" if OS.linux?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "Work items generated", shell_output("bash -c \"#{bin}/bfgminer --benchmark 2>/dev/null <<< q\"")
  end
end
