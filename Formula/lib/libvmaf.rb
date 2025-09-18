class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "7178c4833639e6b989ecae73131d02f70735fdb3fc2c7d84bc36c9c3461d93b1"
  license "BSD-2-Clause-Patent"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "b8c8aae9ca7b114d91800ad06e7b9da7f1fd06712b99fa7054ceada1b0de00bd"
    sha256 cellar: :any,                 arm64_sequoia:  "0809635a529d0e53e927cb9834225210096c625b10ab7eb1211cadf63a1016c5"
    sha256 cellar: :any,                 arm64_sonoma:   "56701b888674f0dfe0e67224cf1e851888b6ab044ac696ced31b13c8c7a61d0b"
    sha256 cellar: :any,                 arm64_ventura:  "ca7a55e4abb5861b0bdc2fbb14fe298e466f9910298e043efc2d47d17332d686"
    sha256 cellar: :any,                 arm64_monterey: "45a7329171c81b91618e385d2d35fedb8dfe91355d0ef4c1aa2951bb0c436aef"
    sha256 cellar: :any,                 sonoma:         "64600bc64ae6dc61c6b9f31c7c4ee35a045b72966ba85d6de1e8f7b0fb575c6f"
    sha256 cellar: :any,                 ventura:        "a021ade94bade88689b21bcf06e6055a9d700ababafe51200620eda29a1e0951"
    sha256 cellar: :any,                 monterey:       "448eaea166d8f6f1c48d72c13fe8d1a46635b54556a6904d1fb351d2fc0d0a80"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "91a91750ff43b3268c96f1a8e678e2fa43ab8773369a1f0b405ac95641a3fbec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d48ccc0729c4d04a062bc060518ea1370101fd52e718bc54fad10a9fb996d3cb"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  uses_from_macos "vim" => :build # needed for xxd

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    system "meson", "setup", "build", "libvmaf", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "model"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libvmaf/libvmaf.h>
      int main() {
        return 0;
      }
    C

    flags = [
      "-I#{HOMEBREW_PREFIX}/include/libvmaf",
      "-L#{lib}",
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
