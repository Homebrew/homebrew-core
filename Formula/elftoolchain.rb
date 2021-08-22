class Elftoolchain < Formula
  desc "Implementation of compilation tools for the ELF object format"
  homepage "https://sourceforge.net/p/elftoolchain/wiki/Home/"
  url "https://downloads.sourceforge.net/project/elftoolchain/Sources/elftoolchain-0.7.1/elftoolchain-0.7.1.tar.bz2"
  sha256 "44f14591fcf21294387215dd7562f3fb4bec2f42f476cf32420a6bbabb2bd2b5"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause"]
  head "https://svn.code.sf.net/p/elftoolchain/code/trunk"

  depends_on "bmake" => :build
  depends_on "subversion" => :build # TODO: remove in the next release
  depends_on "libarchive" # needs headers

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "m4" => :build

  on_macos do
    # TODO: add conflicts after merge
    # conflicts_with "libelf", because: "both install `libelf`"
    # conflicts_with "dwarfutils", because: "both install `libdwarf`"

    # libpe_dos.c:122:6: error: implicit declaration of function 'htole32' is invalid in C99
    patch :p0 do
      url "https://raw.githubusercontent.com/macports/macports-ports/195adb123b397d5ae850d91105f668aff83e8161/devel/elftoolchain/files/patch-byteorder-macros.diff"
      sha256 "c50570ede5ea2885f63ce513b5061069d1e385abce5c4628819adf24efa647ba"
    end
  end

  on_linux do
    keg_only "it conflicts with binutils and elfutils" # more popular implementations
  end

  # Symlink binaries that aren't provided by macOS and don't have link conflicts.
  # - Provided by macOS: ar c++filt ld nm ranlib size strings strip
  # - Formula conflicts: mcs (mono)
  def macos_linked_binaries
    %w[addr2line brandelf elfcopy elfdump findtextrel readelf]
  end

  def install
    # Work around to support Apple Silicon in current release.
    # TODO: Remove in the next release.
    if build.stable? && Hardware::CPU.arm?
      ENV.append "CFLAGS", "-DLIBELF_ARCH=EM_AARCH64 -DLIBELF_BYTEORDER=ELFDATA2LSB -DLIBELF_CLASS=ELFCLASS64"
    end

    # Help find `libarchive` outside default Homebrew prefix
    ENV.append "CFLAGS", "-I#{Formula["libarchive"].opt_include}"
    ENV.append "LDFLAGS", "-L#{Formula["libarchive"].opt_lib}"

    # Prevent bmake from running chown
    inreplace Dir["mk/elftoolchain.{inc,lib}.mk"], "-o ${BINOWN} -g ${BINGRP}", ""

    # install: /usr/local/Cellar/elftoolchain/0.7.1/include/elfdefinitions.h: No such file or directory
    include.mkpath

    # use libexec on macOS to avoid shadowing commands, which break dependent builds
    args = %W[
      BINDIR=#{OS.mac? ? libexec/"bin" : bin}
      INCSDIR=#{include}
      LIBDIR=#{lib}
      MANDIR=#{man}
      INC_INSTALL_OWN=
      LIB_INSTALL_OWN=
      MAN_INSTALL_OWN=
      PROG_INSTALL_OWN=
      WITH_TESTS=no
      MKTEX=no
    ]
    # Work around lsb_release usage in mk/os.Linux.mk: sh: 1: lsb_release: not found
    args << "OS_DISTRIBUTION=" << "OS_DISTRIBUTION_VERSION=" if OS.linux?

    system "bmake", *args
    system "bmake", "install", *args
    return unless OS.mac?

    (libexec/"man").install man1
    macos_linked_binaries.each do |cmd|
      bin.install_symlink libexec/"bin"/cmd
      man1.install_symlink libexec/"man/man1/#{cmd}.1"
    end
  end

  def caveats
    on_macos do
      <<~EOS
        Commands provided by macOS and the `msc` command, which conflicts with `mono`,
        have only been installed into "#{opt_libexec}/bin".
        If you need to use these commands, you can add the directory to your PATH with:
          PATH="#{opt_libexec}/bin:$PATH"
      EOS
    end
  end

  test do
    bindir = OS.mac? ? libexec/"bin" : bin
    assert_match "Usage:", shell_output("#{bindir}/strings #{bindir}/strings")

    elf_content =  "7F454C460101010000000000000000000200030001000000548004083" \
                   "4000000000000000000000034002000010000000000000001000000000000000080040" \
                   "80080040874000000740000000500000000100000B00431DB43B96980040831D2B20CC" \
                   "D8031C040CD8048656C6C6F20776F726C640A"
    File.binwrite(testpath/"elf", [elf_content].pack("H*"))

    (testpath/"test-elf.c").write <<~EOS
      #include <gelf.h>
      #include <fcntl.h>
      #include <stdio.h>

      int main(void) {
        GElf_Ehdr ehdr;
        int fd = open("elf", O_RDONLY, 0);
        if (elf_version(EV_CURRENT) == EV_NONE) return 1;
        Elf *e = elf_begin(fd, ELF_C_READ, NULL);
        if (elf_kind(e) != ELF_K_ELF) return 1;
        if (gelf_getehdr(e, &ehdr) == NULL) return 1;
        printf("%d-bit ELF\\n", gelf_getclass(e) == ELFCLASS32 ? 32 : 64);
        return 0;
      }
    EOS
    system ENV.cc, "test-elf.c", "-L#{lib}", "-I#{include}", "-lelf", "-o", "test-elf"
    assert_match "32-bit ELF", shell_output("./test-elf")

    (testpath/"test-dwarf.c").write <<~EOS
      #include <dwarf.h>
      #include <libdwarf.h>
      #include <stdio.h>
      #include <string.h>

      int main(void) {
        const char *out = NULL;
        int res = dwarf_get_CHILDREN_name(0, &out);

        if (res != DW_DLV_OK) {
          printf("Getting name failed\\n");
          return 1;
        }

        if (strcmp(out, "DW_CHILDREN_no") != 0) {
          printf("Name did not match: %s\\n", out);
          return 1;
        }

        return 0;
      }
    EOS
    system ENV.cc, "test-dwarf.c", "-I#{include}", "-L#{lib}", "-ldwarf", "-lelf", "-o", "test-dwarf"
    system "./test-dwarf"
  end
end
