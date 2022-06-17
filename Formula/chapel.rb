class Chapel < Formula
  desc "Programming language for productive parallel computing at scale"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.26.0/chapel-1.26.0.tar.gz"
  sha256 "ba396b581f0a17f8da3f365a3f8b079b8d2e229a393fbd1756966b0019931ece"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_monterey: "64d6aec51c37987b02b097485e201e6d6bbbf750c4f4ec1f6a0c42a5ad3b00b5"
    sha256 arm64_big_sur:  "2af1e2f47d881b45fceb8269c0e0072651f2c31636d18477a69ed40cfe183425"
    sha256 monterey:       "071524c6a8974377d6331048878bc05213e292995985d7211855a54fe83fb8af"
    sha256 big_sur:        "6357ed5ffe3478282d7260364c9cbbde0b9043c32d6f40057a4906ee2cc364ec"
    sha256 catalina:       "9b6177315ed483d8bf5767d02d911d67aa9968219e21eaca8901a6f0b5c554e5"
    sha256 x86_64_linux:   "2fd94cac965b48ddb70ab6c5d2104c79c9ae8b892f25131a33356ab012dcc5ef"
  end

  depends_on "gmp"
  # `chapel` scripts use python on PATH (e.g. checking `command -v python3`),
  # so it needs to depend on the currently linked Homebrew Python version.
  # TODO: remove from versioned_dependencies_conflicts_allowlist when
  # when Python dependency matches LLVM's Python for all OS versions.
  depends_on "python@3.9"

  on_macos do
    depends_on "llvm" if MacOS.version > :catalina
    # fatal error: cannot open file './sys_basic.h': No such file or directory
    # Issue ref: https://github.com/Homebrew/homebrew-core/issues/96915
    depends_on "llvm@11" if MacOS.version <= :catalina
  end
  on_linux do
    depends_on "llvm"
  end

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
    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec
    ENV["CHPL_GMP"] = "system"
    # This enables a workaround for
    #   https://github.com/llvm/llvm-project/issues/54438
    ENV["CHPL_HOST_USE_SYSTEM_LIBCXX"] = "yes"

    # Must be built from within CHPL_HOME to prevent build bugs.
    # https://github.com/Homebrew/legacy-homebrew/pull/35166
    cd libexec do
      # don't try to set CHPL_LLVM_GCC_PREFIX since the llvm@13
      # package should be configured to use a reasonable GCC
      (libexec/"chplconfig").write <<~EOS
        CHPL_RE2=bundled
        CHPL_GMP=system
        CHPL_LLVM_CONFIG=#{llvm.opt_bin}/llvm-config
        CHPL_LLVM_GCC_PREFIX=none
      EOS

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
