class Mecab < Formula
  desc "Yet another part-of-speech and morphological analyzer"
  homepage "https://taku910.github.io/mecab/"
  # Canonical url is https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE
  url "https://deb.debian.org/debian/pool/main/m/mecab/mecab_0.996.orig.tar.gz"
  sha256 "e073325783135b72e666145c781bb48fada583d5224fb2490fb6c1403ba69c59"
  license any_of: ["GPL-2.0-only", "LGPL-2.1-only", "BSD-3-Clause"]

  livecheck do
    url :homepage
    regex(/mecab[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 6
    sha256 arm64_tahoe:   "72298458bdf93c9012a74c60fb039ad00d77ad89839274c9857743bee97e22f0"
    sha256 arm64_sequoia: "bf11401bae781f9ff7eb147a4c1c6b563bf2f34a8322e0ed5ed4ab5b96de7056"
    sha256 arm64_sonoma:  "a519daec0927f8e41becdb52a94b6f907a86e61876f001be545912686fe203dd"
    sha256 sonoma:        "152e6c5b2d2c3ce712382f25ecc88f0ebad662ed77688e8e9571827883505604"
    sha256 arm64_linux:   "aee232893d116dc8431afa796f10d449236aaf57478e76ee3af5e74665ba12da"
    sha256 x86_64_linux:  "61a01d5c68ef43a4e630e2ba229b5ea640e4da75569a3bee24ebfc8eb9a64abb"
  end

  conflicts_with "mecab-ko", because: "both install mecab binaries"

  def install
    # Put dic files in HOMEBREW_PREFIX/lib instead of lib
    inreplace "mecab-config.in", "@libdir@/mecab/dic", HOMEBREW_PREFIX/"lib/mecab/dic"
    inreplace "mecabrc.in", "@prefix@/lib/mecab/dic", HOMEBREW_PREFIX/"lib/mecab/dic"

    # Help old config scripts identify arm64 linux
    args = ["--build=aarch64-unknown-linux-gnu"] if OS.linux? && Hardware::CPU.arm64?

    # Manually install etc files to avoid overwriting any existing files
    system "./configure", "--sysconfdir=#{etc}", *args, *std_configure_args
    system "make", "install", "sysconfdir=#{prefix}/etc"
    etc.install (prefix/"etc").children
  end

  post_install_steps do
    mkdir_p "lib/mecab/dic", base: :homebrew_prefix
  end

  test do
    assert_equal "#{HOMEBREW_PREFIX}/lib/mecab/dic", shell_output("#{bin}/mecab-config --dicdir").chomp
    return if OS.linux?

    require "utils/linkage"
    library = "/usr/lib/libiconv.2.dylib"
    assert Utils.binary_linked_to_library?(bin/"mecab", library), "No linkage with #{library}!"
  end
end
