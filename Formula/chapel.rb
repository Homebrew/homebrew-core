class Chapel < Formula
  desc "Programming language for productive parallel computing at scale"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.29.0/chapel-1.29.0.tar.gz"
  sha256 "f87bc7285c4641ed540f806c63ab904137b650b1e232a11c15f76e874e079804"
  license "Apache-2.0"
  head "https://github.com/chapel-lang/chapel.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "02f2f907d5564b80034d763144584b56c551d3ee6024dba84f77a18e3581dddf"
    sha256 arm64_monterey: "16e3fd0177ab450a788271b0e38e417ec459fc91d70b8d388a9fe85e78d0291b"
    sha256 arm64_big_sur:  "c36c6e7cf4b30fefb9fe65aec07a04afdb168765c1a417318f75f65df0b4bd94"
    sha256 ventura:        "bc45e9b7ea5aa0cc14b1158c4b62f88498f570a682b4128c2c5feee7ef41e9c8"
    sha256 monterey:       "e2d386f7f931f4c684f5aa325b56c678fc1613935404d40de5d9e09933a3e41b"
    sha256 big_sur:        "97697fee3e47ad73ad0e2cb80078ea2a7dd1110fa06e297e8b076fff4ec3bc84"
    sha256 catalina:       "4a588c9b8fdb17f01109be986a3d8df929eb666ddc403499ffdaabd2d174e8e1"
    sha256 x86_64_linux:   "44e78c563407371437e9cb150ffd1b1f02dfd6f2643ec82d88322ad5665346a1"
  end

  depends_on "cmake"
  depends_on "gmp"
  depends_on "llvm@14"
  depends_on "python@3.10"

  # LLVM is built with gcc11 and we will fail on linux with gcc version 5.xx
  fails_with gcc: "5"

  # Work around Homebrew 11-arm64 CI issue, which outputs unwanted objc warnings like:
  # objc[42134]: Class ... is implemented in both ... One of the two will be used. Which one is undefined.
  # These end up incorrectly failing checkChplInstall test script when it checks for stdout/stderr.
  # TODO: remove when Homebrew CI no longer outputs these warnings or 11-arm64 is no longer used.
  patch :DATA

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    # Always detect Python used as dependency rather than needing aliased Python formula
    python = "python3.10"
    # It should be noted that this will expand to: 'for cmd in python3.10 python3 python python2; do'
    # in our find-python.sh script.
    inreplace "util/config/find-python.sh", /^(for cmd in )(python3 )/, "\\1#{python} \\2"

    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec
    ENV["CHPL_GMP"] = "system"
    # This enables a workaround for
    #   https://github.com/llvm/llvm-project/issues/54438
    ENV["CHPL_HOST_USE_SYSTEM_LIBCXX"] = "yes"

    # don't try to set CHPL_LLVM_GCC_PREFIX since the llvm
    # package should be configured to use a reasonable GCC
    (libexec/"chplconfig").write <<~EOS
      CHPL_RE2=bundled
      CHPL_GMP=system
      CHPL_LLVM_CONFIG=#{llvm.opt_bin}/llvm-config
      CHPL_LLVM_GCC_PREFIX=none
    EOS

    # Must be built from within CHPL_HOME to prevent build bugs.
    # https://github.com/Homebrew/legacy-homebrew/pull/35166
    cd libexec do
      system "./util/printchplenv", "--all"
      with_env(CHPL_PIP_FROM_SOURCE: "1") do
        system "make", "test-venv"
      end
      with_env(CHPL_LLVM: "none") do
        system "make"
      end
      with_env(CHPL_LLVM: "system") do
        system "make"
      end
      with_env(CHPL_PIP_FROM_SOURCE: "1") do
        system "make", "chpldoc"
      end
      system "make", "mason"
      system "make", "cleanall"

      rm_rf("third-party/llvm/llvm-src/")
      rm_rf("third-party/gasnet/gasnet-src")
      rm_rf("third-party/libfabric/libfabric-src")
      rm_rf("third-party/fltk/fltk-1.3.5-source.tar.gz")
      rm_rf("third-party/libunwind/libunwind-1.1.tar.gz")
      rm_rf("third-party/gmp/gmp-src/")
      rm_rf("third-party/qthread/qthread-src/installed")
    end

    # Install chpl and other binaries (e.g. chpldoc) into bin/ as exec scripts.
    platform = if OS.linux? && Hardware::CPU.is_64_bit?
      "linux64-#{Hardware::CPU.arch}"
    else
      "#{OS.kernel_name.downcase}-#{Hardware::CPU.arch}"
    end

    bin.install libexec.glob("bin/#{platform}/*")
    bin.env_script_all_files libexec/"bin"/platform, CHPL_HOME: libexec
    man1.install_symlink libexec.glob("man/man1/*.1")
  end

  test do
    ENV["CHPL_HOME"] = libexec
    ENV["CHPL_INCLUDE_PATH"] = HOMEBREW_PREFIX/"include"
    ENV["CHPL_LIB_PATH"] = HOMEBREW_PREFIX/"lib"
    cd libexec do
      with_env(CHPL_LLVM: "system") do
        system "util/test/checkChplInstall"
      end
      with_env(CHPL_LLVM: "none") do
        system "util/test/checkChplInstall"
      end
    end
    system bin/"chpl", "--print-passes", "--print-commands", libexec/"examples/hello.chpl"
  end
end

__END__
diff --git a/util/test/checkChplInstall b/util/test/checkChplInstall
index 7d2eb78a88..a9ddf22054 100755
--- a/util/test/checkChplInstall
+++ b/util/test/checkChplInstall
@@ -189,6 +189,7 @@ fi
 if [ -n "${TEST_COMP_OUT}" ]; then
     # apply "prediff"-like filter to remove gmake "clock skew detected" warnings, if any
     TEST_COMP_OUT=$( grep <<<"${TEST_COMP_OUT}" -v \
+        -e '^objc\(\[[0-9]*\]\)*: Class .* is implemented in both .* One of the two will be used\. Which one is undefined\. *$' \
         -e '^g*make\(\[[0-9]*\]\)*: Warning: File .* has modification time .* in the future *$' \
         -e '^g*make\(\[[0-9]*\]\)*: warning:  Clock skew detected\.  Your build may be incomplete\. *$' )
 fi
