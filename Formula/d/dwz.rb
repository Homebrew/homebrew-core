class Dwz < Formula
  desc "DWARF optimization and duplicate removal tool for ELF files"
  homepage "https://sourceware.org/dwz/"
  url "https://sourceware.org/ftp/dwz/releases/dwz-0.15.tar.xz"
  sha256 "3c3845310e34e306747207e1038bbc4085c7e2edff8de20f7ca7f3884ca752e4"
  license "GPL-3.0-or-later"

  depends_on "xxhash" => :build
  depends_on "libelf"

  patch do
    # Patch 1: Add my own custom implementation of the linux error() function.
    #   same as I did for the OpenBSD port of dwz
    #   obstack is not a system header
    #   adapt to libelf in Homebrew
    url "https://raw.githubusercontent.com/ibara/homebrew-patches/e2892c4fb1031e1eb6e5c37a0dbf5fc03ba99489/patch-dwz-0.15-dwz_c.diff"
    sha256 "51c0617d1a3a9954af3b1ad2bf82697e3a18c66e93ef0a7bd0a9a86b65c28cda"
  end
  patch do
    # Patch 2: Add implementation of obstack from musl
    url "https://raw.githubusercontent.com/openbsd/ports/85229c97e7dfe165bcf4a5c4aa730320afb448d5/devel/dwz/patches/patch-obstack_c"
    sha256 "00835b5c853c43a3056bea395e5c7d692893a8b9f04af5269967f2e2651aac68"
  end
  patch do
    # Patch 3: Add implementation of obstack header from musl
    url "https://raw.githubusercontent.com/openbsd/ports/85229c97e7dfe165bcf4a5c4aa730320afb448d5/devel/dwz/patches/patch-obstack_h"
    sha256 "d23f6699ad278d5029e5110830147da54c1c592e2cabcea438301c3dcc6975a0"
  end
  patch do
    # Patch 4: We don't have readelf; all Homebrew-supported Macs are 64-bit LE
    #  ensure installation is correct
    #  same as the OpenBSD port
    url "https://raw.githubusercontent.com/ibara/homebrew-patches/e2892c4fb1031e1eb6e5c37a0dbf5fc03ba99489/patch-dwz-0.15-Makefile.diff"
    sha256 "57183f94a245ca977b89817aa8626dd1885962f5b5550d5c69d775faefcf915c"
  end
  patch do
    # Patch 5: We don't need endian.h; we are little endian
    url "https://raw.githubusercontent.com/ibara/homebrew-patches/e2892c4fb1031e1eb6e5c37a0dbf5fc03ba99489/patch-dwz-0.15-hashtab_c.diff"
    sha256 "9b400ae5e62b8c480c8fa163f9fc3c22fce56f23303a5ac50e67fb1bbc0a9b88"
  end
  patch do
    # Patch 6: We don't need endian.h; we are little endian
    url "https://raw.githubusercontent.com/ibara/homebrew-patches/e2892c4fb1031e1eb6e5c37a0dbf5fc03ba99489/patch-dwz-0.15-sha1_c.diff"
    sha256 "70f23a7d88329d2497b0109340dec709d0e353ba9f1fa018dac5a56023c43a92"
  end
  patch do
    # Patch 7: Remove linuxism in getting number of online CPUs
    url "https://raw.githubusercontent.com/ibara/homebrew-patches/e2892c4fb1031e1eb6e5c37a0dbf5fc03ba99489/patch-dwz-0.15-args_c.diff"
    sha256 "45d27ed61c8ccb9a4aab59a4df0a730be753e0ea4376656eebdce7e3f53f7b4a"
  end

  def install
    ENV.append_to_cflags "-g -O2 -DNATIVE_POINTER_SIZE=8 -DNATIVE_ENDIAN_VAL=ELFDATA2LSB"
    ENV.append_to_cflags "-I#{Formula["libelf"].opt_prefix}/include/libelf"
    system "make"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    # Grab a compiled "int main(void){return 0;}" for FreeBSD 14.2 with debug symbols
    # Test to see if dwz correctly optimzes the debug symbols
    system "curl", "-O", "https://raw.githubusercontent.com/ibara/homebrew-patches/refs/heads/main/dwz-test"
    assert_equal "SHA256 (dwz-test) = 007fda3acedabac42d34fc910ff3bc40f5f0ceb2bde113787f999be9029164cc", \
    shell_output("sha256 dwz-test | tr -d '\n'")
    system "#{bin}/dwz", "dwz-test"
    assert_equal "9440", shell_output("ls -l dwz-test | awk '{print $5}' | tr -d '\n'")
  end
end
