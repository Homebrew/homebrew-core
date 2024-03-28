class AflPlusPlus < Formula
  desc "American fuzzy lop plus plus: Security-oriented fuzzer, community-maintained"
  homepage "https://github.com/AFLplusplus/AFLplusplus"
  url "https://github.com/AFLplusplus/AFLplusplus.git",
      tag:      "v4.10c",
      revision: "775861ea94d00672c9e868db329073afd699b994"
  version "4.10c"
  license "Apache-2.0"
  head "https://github.com/AFLplusplus/AFLplusplus.git",
       branch: "dev"

  depends_on "llvm"
  depends_on "python@3.12"

  conflicts_with "afl-fuzz", because: "they are different versions of the same software"

  # Fix incompatibility with BSD coreutils.  Also, we don't want to
  # alter the testing environment, and test_shm fails on macOS by
  # default and hinders installation of working stuff so just remove
  # that check entirely.
  patch :DATA

  def install
    ENV["CC"] = Formula["llvm"].bin/"clang"
    ENV["CXX"] = Formula["llvm"].bin/"clang++"
    ENV["LLVM_CONFIG"] = Formula["llvm"].bin/"llvm-config"
    ENV["PREFIX"] = prefix

    system "make", "distrib", "install", "AFL_NO_X86=1"
  end

  test do
    cpp_file = testpath/"main.cpp"
    cpp_file.write <<~EOS
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    EOS

    system bin/"afl-clang-fast++", "-g", cpp_file, "-o", "test", "--afl-noopt"
    assert_equal "Hello, world!", shell_output("./test")
  end
end
__END__
diff --git a/GNUmakefile b/GNUmakefile
index 283c57c28faed4581c94bceefc0aa3d9b64a8d0a..000f15c089309d43cb859e4471e84066416b66c8 100644
--- a/GNUmakefile
+++ b/GNUmakefile
@@ -183,7 +183,6 @@ ifeq "$(SYS)" "NetBSD"
 endif
 
 ifeq "$(SYS)" "Haiku"
-  SHMAT_OK=0
   override CFLAGS  += -DUSEMMAP=1 -Wno-error=format
   override LDFLAGS += -Wno-deprecated-declarations -lgnu -lnetwork
   #SPECIAL_PERFORMANCE += -DUSEMMAP=1
@@ -304,22 +303,11 @@ ifeq "$(shell echo 'int main() { return 0;}' | $(CC) $(CFLAGS) -fsanitize=addres
 	ASAN_LDFLAGS=-fsanitize=address -fstack-protector-all -fno-omit-frame-pointer
 endif
 
-ifeq "$(shell echo '$(HASH)include <sys/ipc.h>@$(HASH)include <sys/shm.h>@int main() { int _id = shmget(IPC_PRIVATE, 65536, IPC_CREAT | IPC_EXCL | 0600); shmctl(_id, IPC_RMID, 0); return 0;}' | tr @ '\n' | $(CC) $(CFLAGS) -x c - -o .test2 2>/dev/null && echo 1 || echo 0 ; rm -f .test2 )" "1"
-	SHMAT_OK=1
-else
-	SHMAT_OK=0
-	override CFLAGS+=-DUSEMMAP=1
-	LDFLAGS += -Wno-deprecated-declarations
-endif
-
-ifdef TEST_MMAP
-	SHMAT_OK=0
-	override CFLAGS += -DUSEMMAP=1
-	LDFLAGS += -Wno-deprecated-declarations
-endif
+override CFLAGS+=-DUSEMMAP=1
+LDFLAGS += -Wno-deprecated-declarations
 
 .PHONY: all
-all:	test_x86 test_shm test_python ready $(PROGS) afl-as llvm gcc_plugin test_build all_done
+all:	test_x86 test_python ready $(PROGS) afl-as llvm gcc_plugin test_build all_done
 	-$(MAKE) -C utils/aflpp_driver
 	@echo
 	@echo
@@ -424,16 +412,6 @@ test_x86:
 	@echo "[!] Note: skipping x86 compilation checks (AFL_NO_X86 set)."
 endif
 
-.PHONY: test_shm
-ifeq "$(SHMAT_OK)" "1"
-test_shm:
-	@echo "[+] shmat seems to be working."
-	@rm -f .test2
-else
-test_shm:
-	@echo "[-] shmat seems not to be working, switching to mmap implementation"
-endif
-
 .PHONY: test_python
 ifeq "$(PYTHON_OK)" "1"
 test_python:
@@ -674,7 +652,7 @@ endif
 endif
 
 .PHONY: binary-only
-binary-only: test_shm test_python ready $(PROGS)
+binary-only: test_python ready $(PROGS)
 ifneq "$(SYS)" "Darwin"
 	-$(MAKE) -C utils/libdislocator
 	-$(MAKE) -C utils/libtokencap
diff --git a/GNUmakefile.gcc_plugin b/GNUmakefile.gcc_plugin
index 8f06792dc4d21cd593926498004028962381c84e..359ee309b1b85cd8e1bef4ee2a436541f0cc6166 100644
--- a/GNUmakefile.gcc_plugin
+++ b/GNUmakefile.gcc_plugin
@@ -67,17 +67,7 @@ HASH=\#
 GCCVER    = $(shell $(CC) --version 2>/dev/null | awk 'NR == 1 {print $$NF}')
 GCCBINDIR = $(shell dirname `command -v $(CC)` 2>/dev/null )
 
-ifeq "$(shell echo '$(HASH)include <sys/ipc.h>@$(HASH)include <sys/shm.h>@int main() { int _id = shmget(IPC_PRIVATE, 65536, IPC_CREAT | IPC_EXCL | 0600); shmctl(_id, IPC_RMID, 0); return 0;}' | tr @ '\n' | $(CC) -x c - -o .test2 2>/dev/null && echo 1 || echo 0 ; rm -f .test2 )" "1"
-	SHMAT_OK=1
-else
-	SHMAT_OK=0
-	override CFLAGS_SAFE += -DUSEMMAP=1
-endif
-
-ifeq "$(TEST_MMAP)" "1"
-	SHMAT_OK=0
-	override CFLAGS_SAFE += -DUSEMMAP=1
-endif
+override CFLAGS_SAFE += -DUSEMMAP=1
 
 ifneq "$(SYS)" "Haiku"
 ifneq "$(SYS)" "OpenBSD"
@@ -107,17 +97,7 @@ PASSES       = ./afl-gcc-pass.so ./afl-gcc-cmplog-pass.so ./afl-gcc-cmptrs-pass.
 PROGS        = $(PASSES) ./afl-compiler-rt.o ./afl-compiler-rt-32.o ./afl-compiler-rt-64.o
 
 .PHONY: all
-all: test_shm test_deps $(PROGS) test_build all_done
-
-.PHONY: test_shm
-ifeq "$(SHMAT_OK)" "1"
-test_shm:
-	@echo "[+] shmat seems to be working."
-	@rm -f .test2
-else
-test_shm:
-	@echo "[-] shmat seems not to be working, switching to mmap implementation"
-endif
+all: test_deps $(PROGS) test_build all_done
 
 .PHONY: test_deps
 test_deps:
diff --git a/GNUmakefile.llvm b/GNUmakefile.llvm
index ec8fefe43ea9f0c8fa79cbdc106f00c753294967..7e19c0d6bd5f707c9a31f2053b396e7e8e062583 100644
--- a/GNUmakefile.llvm
+++ b/GNUmakefile.llvm
@@ -326,19 +326,8 @@ ifeq "$(SYS)" "OpenBSD"
   LDFLAGS += -lc++abi -lpthread
 endif
 
-ifeq "$(shell echo '$(HASH)include <sys/ipc.h>@$(HASH)include <sys/shm.h>@int main() { int _id = shmget(IPC_PRIVATE, 65536, IPC_CREAT | IPC_EXCL | 0600); shmctl(_id, IPC_RMID, 0); return 0;}' | tr @ '\n' | $(CC) -x c - -o .test2 2>/dev/null && echo 1 || echo 0 ; rm -f .test2 )" "1"
-        SHMAT_OK=1
-else
-        SHMAT_OK=0
-        CFLAGS_SAFE += -DUSEMMAP=1
-        LDFLAGS += -Wno-deprecated-declarations
-endif
-
-ifeq "$(TEST_MMAP)" "1"
-        SHMAT_OK=0
-        CFLAGS_SAFE += -DUSEMMAP=1
-        LDFLAGS += -Wno-deprecated-declarations
-endif
+CFLAGS_SAFE += -DUSEMMAP=1
+LDFLAGS += -Wno-deprecated-declarations
 
 PROGS_ALWAYS = ./afl-cc ./afl-compiler-rt.o ./afl-compiler-rt-32.o ./afl-compiler-rt-64.o 
 PROGS        = $(PROGS_ALWAYS) ./afl-llvm-pass.so ./SanitizerCoveragePCGUARD.so ./split-compares-pass.so ./split-switches-pass.so ./cmplog-routines-pass.so ./cmplog-instructions-pass.so ./cmplog-switches-pass.so ./afl-llvm-dict2file.so ./compare-transform-pass.so ./afl-ld-lto ./afl-llvm-lto-instrumentlist.so ./SanitizerCoverageLTO.so ./injection-pass.so
@@ -353,9 +342,9 @@ ifneq "$(LLVM_UNSUPPORTED)$(LLVM_APPLE_XCODE)" "00"
 endif
 
 ifeq "$(NO_BUILD)" "1"
-  TARGETS = test_shm $(PROGS_ALWAYS) afl-cc.8
+  TARGETS = $(PROGS_ALWAYS) afl-cc.8
 else
-  TARGETS = test_shm test_deps $(PROGS) afl-cc.8 test_build all_done
+  TARGETS = test_deps $(PROGS) afl-cc.8 test_build all_done
 endif
 
 LLVM_MIN_4_0_1 = $(shell awk 'function tonum(ver, a) {split(ver,a,"."); return a[1]*1000000+a[2]*1000+a[3]} BEGIN { exit tonum(ARGV[1]) >= tonum(ARGV[2]) }' $(LLVMVER) 4.0.1; echo $$?)
@@ -363,16 +352,6 @@ LLVM_MIN_4_0_1 = $(shell awk 'function tonum(ver, a) {split(ver,a,"."); return a
 .PHONY: all
 all: $(TARGETS)
 
-.PHONY: test_shm
-ifeq "$(SHMAT_OK)" "1"
-test_shm:
-	@echo "[+] shmat seems to be working."
-	@rm -f .test2
-else
-test_shm:
-	@echo "[-] shmat seems not to be working, switching to mmap implementation"
-endif
-
 .PHONY: no_build
 no_build:
 	@printf "%b\\n" "\\033[0;31mPrerequisites are not met, skipping build llvm_mode\\033[0m"
diff --git a/utils/afl_network_proxy/GNUmakefile b/utils/afl_network_proxy/GNUmakefile
index 7c8c22ff9ae82d3f6991a290a0394a2b736e44c5..27952a55272b261d8ff4cb857d868cd6eda8af3f 100644
--- a/utils/afl_network_proxy/GNUmakefile
+++ b/utils/afl_network_proxy/GNUmakefile
@@ -46,5 +46,5 @@ clean:
 install: all
 	install -d -m 755 $${DESTDIR}$(BIN_PATH) $${DESTDIR}$(DOC_PATH)
 	install -m 755 $(PROGRAMS) $${DESTDIR}$(BIN_PATH)
-	install -T -m 644 README.md $${DESTDIR}$(DOC_PATH)/README.network_proxy.md
+	install -m 644 README.md $${DESTDIR}$(DOC_PATH)/README.network_proxy.md
 
