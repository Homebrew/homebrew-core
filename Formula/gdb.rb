class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-8.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-8.2.tar.xz"
  sha256 "c3a441a29c7c89720b734e5a9c6289c0a06be7e0c76ef538f7bbcef389347c39"
  revision 1

  bottle do
    sha256 "66aba1de069c94a7dbd24da8f29bba8a2415ba04ca55fc7e57fa33fa482885c4" => :mojave
    sha256 "6d35586ed4c646df660b4518838f7809c593a851ad171b86d5d44b6d30c780b4" => :high_sierra
    sha256 "bbf55e88a59cc9ccedd9771a8cab1c57a5395bbbb91ece45daa1214a2b36f5b9" => :sierra
    sha256 "cd3d64855ad850a25bdf7cb031ae837138579afbd2faebb5ec806dd3d22ca960" => :el_capitan
  end

  option "with-python", "Use the Homebrew version of Python; by default system Python is used"
  option "with-python@2", "Use the Homebrew version of Python 2; by default system Python is used"
  option "with-version-suffix", "Add a version suffix to program"
  option "with-all-targets", "Build with support for all targets"

  deprecated_option "with-brewed-python" => "with-python@2"
  deprecated_option "with-guile" => "with-guile@2.0"

  depends_on "pkg-config" => :build
  depends_on "guile@2.0" => :optional
  depends_on "python" => :optional
  depends_on "python@2" => :optional

  fails_with :clang do
    build 800
    cause <<~EOS
      probe.c:63:28: error: default initialization of an object of const type
      'const any_static_probe_ops' without a user-provided default constructor
    EOS
  end

  fails_with :clang do
    build 600
    cause <<~EOS
      clang: error: unable to execute command: Segmentation fault: 11
      Test done on: Apple LLVM version 6.0 (clang-600.0.56) (based on LLVM 3.5svn)
    EOS
  end

  # Fix compilation --with-all-targets using upstream commit:
  # https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;a=commitdiff;h=0c0a40e0
  # Remove with next version
  patch :p0, :DATA

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
    ]

    args << "--with-guile" if build.with? "guile@2.0"
    args << "--enable-targets=all" if build.with? "all-targets"

    if build.with?("python@2") && build.with?("python")
      odie "Options --with-python and --with-python@2 are mutually exclusive."
    elsif build.with?("python@2")
      args << "--with-python=#{Formula["python@2"].opt_bin}/python2"
      ENV.append "CPPFLAGS", "-I#{Formula["python@2"].opt_libexec}"
    elsif build.with?("python")
      args << "--with-python=#{Formula["python"].opt_bin}/python3"
      ENV.append "CPPFLAGS", "-I#{Formula["python"].opt_libexec}"
    else
      args << "--with-python=/usr"
    end

    if build.with? "version-suffix"
      args << "--program-suffix=-#{version.to_s.slice(/^\d/)}"
    end

    system "./configure", *args
    system "make"

    # Don't install bfd or opcodes, as they are provided by binutils
    inreplace ["bfd/Makefile", "opcodes/Makefile"], /^install:/, "dontinstall:"

    system "make", "install"
  end

  def caveats; <<~EOS
    gdb requires special privileges to access Mach ports.
    You will need to codesign the binary. For instructions, see:

      https://sourceware.org/gdb/wiki/BuildingOnDarwin

    On 10.12 (Sierra) or later with SIP, you need to run this:

      echo "set startup-with-shell off" >> ~/.gdbinit
  EOS
  end

  test do
    system bin/"gdb", bin/"gdb", "-configuration"
  end
end

__END__

diff -Naru /tmp/aarch64-linux-tdep.c gdb/aarch64-linux-tdep.c.new
--- gdb/aarch64-linux-tdep.c	2018-09-27 21:05:15.000000000 -0700
+++ gdb/aarch64-linux-tdep.c.new	2018-09-27 21:05:47.000000000 -0700
@@ -315,7 +315,7 @@
      passed in SVE regset or a NEON fpregset.  */

   /* Extract required fields from the header.  */
-  uint64_t vl = extract_unsigned_integer (header + SVE_HEADER_VL_OFFSET,
+  ULONGEST vl = extract_unsigned_integer (header + SVE_HEADER_VL_OFFSET,
					  SVE_HEADER_VL_LENGTH, byte_order);
   uint16_t flags = extract_unsigned_integer (header + SVE_HEADER_FLAGS_OFFSET,
					     SVE_HEADER_FLAGS_LENGTH,
diff --git bfd/mach-o.c bfd/mach-o.c
index ce72a3d..2c060a7 100644
--- bfd/mach-o.c
+++ bfd/mach-o.c
@@ -4595,16 +4595,12 @@ bfd_mach_o_read_version_min (bfd *abfd, bfd_mach_o_load_command *command)
 {
   bfd_mach_o_version_min_command *cmd = &command->command.version_min;
   struct mach_o_version_min_command_external raw;
-  unsigned int ver;
 
   if (bfd_bread (&raw, sizeof (raw), abfd) != sizeof (raw))
     return FALSE;
 
-  ver = bfd_get_32 (abfd, raw.version);
-  cmd->rel = ver >> 16;
-  cmd->maj = ver >> 8;
-  cmd->min = ver;
-  cmd->reserved = bfd_get_32 (abfd, raw.reserved);
+  cmd->version = bfd_get_32 (abfd, raw.version);
+  cmd->sdk = bfd_get_32 (abfd, raw.sdk);
   return TRUE;
 }
 
@@ -4678,6 +4674,37 @@ bfd_mach_o_read_source_version (bfd *abfd, bfd_mach_o_load_command *command)
   return TRUE;
 }
 
+static bfd_boolean
+bfd_mach_o_read_note (bfd *abfd, bfd_mach_o_load_command *command)
+{
+  bfd_mach_o_note_command *cmd = &command->command.note;
+  struct mach_o_note_command_external raw;
+
+  if (bfd_bread (&raw, sizeof (raw), abfd) != sizeof (raw))
+    return FALSE;
+
+  memcpy (cmd->data_owner, raw.data_owner, 16);
+  cmd->offset = bfd_get_64 (abfd, raw.offset);
+  cmd->size = bfd_get_64 (abfd, raw.size);
+  return TRUE;
+}
+
+static bfd_boolean
+bfd_mach_o_read_build_version (bfd *abfd, bfd_mach_o_load_command *command)
+{
+  bfd_mach_o_build_version_command *cmd = &command->command.build_version;
+  struct mach_o_build_version_command_external raw;
+
+  if (bfd_bread (&raw, sizeof (raw), abfd) != sizeof (raw))
+    return FALSE;
+
+  cmd->platform = bfd_get_32 (abfd, raw.platform);
+  cmd->minos = bfd_get_32 (abfd, raw.minos);
+  cmd->sdk = bfd_get_32 (abfd, raw.sdk);
+  cmd->ntools = bfd_get_32 (abfd, raw.ntools);
+  return TRUE;
+}
+
 static bfd_boolean
 bfd_mach_o_read_segment (bfd *abfd,
 			 bfd_mach_o_load_command *command,
@@ -4874,6 +4901,7 @@ bfd_mach_o_read_command (bfd *abfd, bfd_mach_o_load_command *command)
     case BFD_MACH_O_LC_VERSION_MIN_MACOSX:
     case BFD_MACH_O_LC_VERSION_MIN_IPHONEOS:
     case BFD_MACH_O_LC_VERSION_MIN_WATCHOS:
+    case BFD_MACH_O_LC_VERSION_MIN_TVOS:
       if (!bfd_mach_o_read_version_min (abfd, command))
 	return FALSE;
       break;
@@ -4885,6 +4913,16 @@ bfd_mach_o_read_command (bfd *abfd, bfd_mach_o_load_command *command)
       if (!bfd_mach_o_read_source_version (abfd, command))
 	return FALSE;
       break;
+    case BFD_MACH_O_LC_LINKER_OPTIONS:
+      break;
+    case BFD_MACH_O_LC_NOTE:
+      if (!bfd_mach_o_read_note (abfd, command))
+        return FALSE;
+      break;
+     case BFD_MACH_O_LC_BUILD_VERSION:
+      if (!bfd_mach_o_read_build_version (abfd, command))
+        return FALSE;
+       break;
     default:
       command->len = 0;
       _bfd_error_handler (_("%pB: unknown load command %#x"),
diff --git bfd/mach-o.h bfd/mach-o.h
index d80d439..61428d6 100644
--- bfd/mach-o.h
+++ bfd/mach-o.h
@@ -113,6 +113,18 @@ bfd_mach_o_segment_command;
 #define BFD_MACH_O_PROT_WRITE   0x02
 #define BFD_MACH_O_PROT_EXECUTE 0x04
 
+/* Target platforms.  */
+#define BFD_MACH_O_PLATFORM_MACOS    1
+#define BFD_MACH_O_PLATFORM_IOS      2
+#define BFD_MACH_O_PLATFORM_TVOS     3
+#define BFD_MACH_O_PLATFORM_WATCHOS  4
+#define BFD_MACH_O_PLATFORM_BRIDGEOS 5
+
+/* Build tools.  */
+#define BFD_MACH_O_TOOL_CLANG 1
+#define BFD_MACH_O_TOOL_SWIFT 2
+#define BFD_MACH_O_TOOL_LD    3
+
 /* Expanded internal representation of a relocation entry.  */
 typedef struct bfd_mach_o_reloc_info
 {
@@ -519,10 +531,8 @@ bfd_mach_o_dyld_info_command;
 
 typedef struct bfd_mach_o_version_min_command
 {
-  unsigned char rel;
-  unsigned char maj;
-  unsigned char min;
-  unsigned int reserved;
+  uint32_t version;
+  uint32_t sdk;
 }
 bfd_mach_o_version_min_command;
 
@@ -551,6 +561,30 @@ typedef struct bfd_mach_o_source_version_command
 }
 bfd_mach_o_source_version_command;
 
+typedef struct bfd_mach_o_note_command
+{
+  char data_owner[16];
+  bfd_uint64_t offset;
+  bfd_uint64_t size;
+}
+bfd_mach_o_note_command;
+
+typedef struct bfd_mach_o_build_version_tool
+{
+  uint32_t tool;
+  uint32_t version;
+}
+bfd_mach_o_build_version_tool;
+
+typedef struct bfd_mach_o_build_version_command
+{
+  uint32_t platform;
+  uint32_t minos;
+  uint32_t sdk;
+  uint32_t ntools;
+}
+bfd_mach_o_build_version_command;
+
 typedef struct bfd_mach_o_load_command
 {
   /* Next command in the single linked list.  */
@@ -584,6 +618,8 @@ typedef struct bfd_mach_o_load_command
     bfd_mach_o_fvmlib_command fvmlib;
     bfd_mach_o_main_command main;
     bfd_mach_o_source_version_command source_version;
+    bfd_mach_o_note_command note;
+    bfd_mach_o_build_version_command build_version;
   } command;
 }
 bfd_mach_o_load_command;
@@ -617,10 +653,10 @@ typedef struct mach_o_data_struct
   /* A place to stash dwarf2 info for this bfd.  */
   void *dwarf2_find_line_info;
 
-  /* BFD of .dSYM file. */
+  /* BFD of .dSYM file.  */
   bfd *dsym_bfd;
 
-  /* Cache of dynamic relocs. */
+  /* Cache of dynamic relocs.  */
   arelent *dyn_reloc_cache;
 }
 bfd_mach_o_data_struct;
diff --git include/mach-o/external.h include/mach-o/external.h
index 2609bad..bf3c0c8 100644
--- include/mach-o/external.h
+++ include/mach-o/external.h
@@ -308,7 +308,7 @@ struct mach_o_twolevel_hints_command_external
 struct mach_o_version_min_command_external
 {
   unsigned char version[4];
-  unsigned char reserved[4];
+  unsigned char sdk[4];
 };
 
 struct mach_o_encryption_info_command_external
@@ -345,12 +345,27 @@ struct mach_o_source_version_command_external
 				   and 24 bits for A.  */
 };
 
+struct mach_o_note_command_external
+{
+  unsigned char data_owner[16]; /* Owner name for this note.  */
+  unsigned char offset[8];      /* File offset of the note.  */
+  unsigned char size[8];        /* Length of the note.  */
+};
+
+struct mach_o_build_version_command_external
+{
+  unsigned char platform[4];    /* Target platform.  */
+  unsigned char minos[4];       /* X.Y.Z is encoded in nibbles xxxx.yy.zz.  */
+  unsigned char sdk[4];         /* X.Y.Z is encoded in nibbles xxxx.yy.zz.  */
+  unsigned char ntools[4];      /* Number of tool entries following this.  */
+};
+
 /* The LD_DATA_IN_CODE command use a linkedit_data_command that points to
    a table of entries.  */
 
 struct mach_o_data_in_code_entry_external
 {
-  unsigned char offset[4];	/* Offset from the mach_header. */
+  unsigned char offset[4];	/* Offset from the mach_header.  */
   unsigned char length[2];	/* Number of bytes.  */
   unsigned char kind[2];	/* Kind.  See BFD_MACH_O_DICE_ values.  */
 };
diff --git include/mach-o/loader.h include/mach-o/loader.h
index c075a8e..c7a06d3 100644
--- include/mach-o/loader.h
+++ include/mach-o/loader.h
@@ -161,31 +161,34 @@ typedef enum bfd_mach_o_load_command_type
   /* Load a dynamically linked shared library that is allowed to be
        missing (weak).  */
   BFD_MACH_O_LC_LOAD_WEAK_DYLIB = 0x18,
-  BFD_MACH_O_LC_SEGMENT_64 = 0x19,	/* 64-bit segment of this file to be
-                                           mapped.  */
-  BFD_MACH_O_LC_ROUTINES_64 = 0x1a,     /* Address of the dyld init routine
-                                           in a dylib.  */
-  BFD_MACH_O_LC_UUID = 0x1b,            /* 128-bit UUID of the executable.  */
-  BFD_MACH_O_LC_RPATH = 0x1c,		/* Run path addiions.  */
-  BFD_MACH_O_LC_CODE_SIGNATURE = 0x1d,	/* Local of code signature.  */
-  BFD_MACH_O_LC_SEGMENT_SPLIT_INFO = 0x1e, /* Local of info to split seg.  */
-  BFD_MACH_O_LC_REEXPORT_DYLIB = 0x1f,  /* Load and re-export lib.  */
-  BFD_MACH_O_LC_LAZY_LOAD_DYLIB = 0x20, /* Delay load of lib until use.  */
-  BFD_MACH_O_LC_ENCRYPTION_INFO = 0x21, /* Encrypted segment info.  */
-  BFD_MACH_O_LC_DYLD_INFO = 0x22,	/* Compressed dyld information.  */
-  BFD_MACH_O_LC_LOAD_UPWARD_DYLIB = 0x23, /* Load upward dylib.  */
-  BFD_MACH_O_LC_VERSION_MIN_MACOSX = 0x24,   /* Minimal MacOSX version.  */
-  BFD_MACH_O_LC_VERSION_MIN_IPHONEOS = 0x25, /* Minimal IOS version.  */
-  BFD_MACH_O_LC_FUNCTION_STARTS = 0x26,  /* Compressed table of func start.  */
-  BFD_MACH_O_LC_DYLD_ENVIRONMENT = 0x27, /* Env variable string for dyld.  */
-  BFD_MACH_O_LC_MAIN = 0x28,             /* Entry point.  */
-  BFD_MACH_O_LC_DATA_IN_CODE = 0x29,     /* Table of non-instructions.  */
-  BFD_MACH_O_LC_SOURCE_VERSION = 0x2a,   /* Source version.  */
-  BFD_MACH_O_LC_DYLIB_CODE_SIGN_DRS = 0x2b, /* DRs from dylibs.  */
-  BFD_MACH_O_LC_ENCRYPTION_INFO_64 = 0x2c, /* Encrypted 64 bit seg info.  */
-  BFD_MACH_O_LC_LINKER_OPTIONS = 0x2d,	/* Linker options.  */
-  BFD_MACH_O_LC_LINKER_OPTIMIZATION_HINT = 0x2e, /* Optimization hints.  */
-  BFD_MACH_O_LC_VERSION_MIN_WATCHOS = 0x30 /* Minimal WatchOS version.  */
+  BFD_MACH_O_LC_SEGMENT_64 = 0x19,             /* 64-bit segment of this file to be
+                                                  mapped.  */
+  BFD_MACH_O_LC_ROUTINES_64 = 0x1a,            /* Address of the dyld init routine
+                                                  in a dylib.  */
+  BFD_MACH_O_LC_UUID = 0x1b,                   /* 128-bit UUID of the executable.  */
+  BFD_MACH_O_LC_RPATH = 0x1c,                  /* Run path addiions.  */
+  BFD_MACH_O_LC_CODE_SIGNATURE = 0x1d,         /* Local of code signature.  */
+  BFD_MACH_O_LC_SEGMENT_SPLIT_INFO = 0x1e,     /* Local of info to split seg.  */
+  BFD_MACH_O_LC_REEXPORT_DYLIB = 0x1f,         /* Load and re-export lib.  */
+  BFD_MACH_O_LC_LAZY_LOAD_DYLIB = 0x20,                /* Delay load of lib until use.  */
+  BFD_MACH_O_LC_ENCRYPTION_INFO = 0x21,                /* Encrypted segment info.  */
+  BFD_MACH_O_LC_DYLD_INFO = 0x22,              /* Compressed dyld information.  */
+  BFD_MACH_O_LC_LOAD_UPWARD_DYLIB = 0x23,      /* Load upward dylib.  */
+  BFD_MACH_O_LC_VERSION_MIN_MACOSX = 0x24,     /* Minimal MacOSX version.  */
+  BFD_MACH_O_LC_VERSION_MIN_IPHONEOS = 0x25,   /* Minimal IOS version.  */
+  BFD_MACH_O_LC_FUNCTION_STARTS = 0x26,        /* Compressed table of func start.  */
+  BFD_MACH_O_LC_DYLD_ENVIRONMENT = 0x27,       /* Env variable string for dyld.  */
+  BFD_MACH_O_LC_MAIN = 0x28,                   /* Entry point.  */
+  BFD_MACH_O_LC_DATA_IN_CODE = 0x29,           /* Table of non-instructions.  */
+  BFD_MACH_O_LC_SOURCE_VERSION = 0x2a,         /* Source version.  */
+  BFD_MACH_O_LC_DYLIB_CODE_SIGN_DRS = 0x2b,    /* DRs from dylibs.  */
+  BFD_MACH_O_LC_ENCRYPTION_INFO_64 = 0x2c,     /* Encrypted 64 bit seg info.  */
+  BFD_MACH_O_LC_LINKER_OPTIONS = 0x2d,         /* Linker options.  */
+  BFD_MACH_O_LC_LINKER_OPTIMIZATION_HINT = 0x2e,/* Optimization hints.  */
+  BFD_MACH_O_LC_VERSION_MIN_TVOS = 0x2f,       /* Minimal tvOS version.  */
+  BFD_MACH_O_LC_VERSION_MIN_WATCHOS = 0x30,    /* Minimal WatchOS version.  */
+  BFD_MACH_O_LC_NOTE = 0x31,                   /* Region of arbitrary data.  */
+  BFD_MACH_O_LC_BUILD_VERSION = 0x32,          /* Generic build version.  */
 }
 bfd_mach_o_load_command_type;
