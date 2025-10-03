class Dwarf < Formula
  desc "Object file manipulation tool"
  homepage "https://github.com/elboza/dwarf-ng/"
  url "https://github.com/elboza/dwarf-ng/archive/refs/tags/dwarf-0.4.0.tar.gz"
  sha256 "a64656f53ded5166041ae25cc4b1ad9ab5046a5c4d4c05b727447e73c0d83da0"
  license "GPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "54cf031b663cb175ebbdb2d6a9015afe24864ea2e46b531a67b6097e648ab636"
    sha256 cellar: :any,                 arm64_sequoia:  "18e5a2ac12431c5fd538a6c1101b53b8fb2c45652d0c6c9c84b30c36534293e9"
    sha256 cellar: :any,                 arm64_sonoma:   "2178e68ea91b6f9482ba9370ff84700d32689188cdcdf0de7eddacd650a42b66"
    sha256 cellar: :any,                 arm64_ventura:  "d0244af1e2cc656fa2c4d040caef6910ffdc6a8cff2480d315db3bc9fbe0a9e3"
    sha256 cellar: :any,                 arm64_monterey: "0bd56303a2a78e899a035597b779d5a3701f911ebfdf586d4a41d660f13253fe"
    sha256 cellar: :any,                 arm64_big_sur:  "30b7f9852b68c70d6e8e07c0de3e9075a4e0edd0facc219970de6535e5931b4d"
    sha256 cellar: :any,                 sonoma:         "262e43f2bad21b879f0a778064aefc3c5aa5ba9a04d74169a8681399a0028a9d"
    sha256 cellar: :any,                 ventura:        "bce795ff823288cbfe918b0b3f8ed08f9cd7aab506e25fe104ff15d9174c2079"
    sha256 cellar: :any,                 monterey:       "cf1b9df9782554d32d6827b89b29195ed7f391a37cd0b9cbab9a63e0ceacec20"
    sha256 cellar: :any,                 big_sur:        "b0bec07c54898e3506e249b3c18fde361772367f1e2d8cc2ee6726a678aea7cd"
    sha256 cellar: :any,                 catalina:       "1d0e1d803ab771d58a56cd52939d01b7c9e1a8474cb80c21b2251320340e5dc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bb1f87a3d1dc58e5d5d651e9645a08653db6835b0503ec8f780a0dbbd7a87443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15de6388ac637850379a4b2cf37e2089b97b96cf0df0ed536f3c7b7b19a9c641"
  end

  depends_on "flex"
  depends_on "readline"

  uses_from_macos "bison" => :build

  def install
    # Workaround for newer Clang
    if DevelopmentTools.clang_build_version >= 1500
      inreplace "src/Makefile", "-Wall", "-Wall -Wno-incompatible-function-pointer-types"
    end

    # Work around failure from GCC 10+ using default of `-fno-common`
    # /usr/bin/ld: repl.o:(.bss+0x20): multiple definition of `fc_ptr'
    args = ENV.compiler.to_s.start_with?("gcc") ? ["CC=#{ENV.cc} -fcommon"] : []

    %w[src/libdwarf.c doc/dwarf.man doc/xdwarf.man.html].each do |f|
      inreplace f, "/etc/dwarfrc", etc/"dwarfrc"
    end

    system "make", *args
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man1}"
  end

  test do
    if OS.mac?
      (testpath/"test.c").write <<~C
        #include <stdio.h>

        int main(int argc, char *argv[]) {
          printf("hello world\\n");
        }
      C
      system ENV.cc, "test.c", "-o", "test"
      output = shell_output("#{bin}/dwarf -c 'pp $mac' test")
      assert_equal "magic: 0xfeedfacf (-17958193)", output.lines[0].chomp
    else
      # Run test on x86-64 ELF as upstream never added EH_AARCH64 so part of
      # output doesn't show correctly if test is run on aarch64 ELF.
      assert_match "main header: elf", shell_output("#{bin}/dwarf -p #{test_fixtures("elf/hello")}")
    end
  end
end
