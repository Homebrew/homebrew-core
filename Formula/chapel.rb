class Chapel < Formula
  desc "Programming language for productive parallel computing at scale"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.31.0/chapel-1.31.0.tar.gz"
  sha256 "4b861c9a354f6fcf66081256f7ec703d6dd2cd68ea363b400d10ac00bf308679"
  license "Apache-2.0"
  head "https://github.com/chapel-lang/chapel.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "8563f116d96b3c89a6de8316020ab25fd27be13f7641d8f223c7c79770eba8ca"
    sha256 arm64_monterey: "6f6da8d43cd744b9e6a8f0026962dcb66c86fe4ffb5dc684e5302a58fbd01247"
    sha256 arm64_big_sur:  "d8e8968e2a6a885e54ae793a64f3c04808325bd9b35544605f39a4402c827a53"
    sha256 ventura:        "fd44d28f8b6a382bda9e5674751b6a0033b9f5a42ab836ac7b305a9a3ba43167"
    sha256 monterey:       "5a446383b71d0ceb4dec422970758814f42f938ead19691797cfb8a549e82fcf"
    sha256 big_sur:        "d0ec7384c879c36473cd676307d4364d4275d3a9153975c1fa0a1c6057bedcec"
    sha256 x86_64_linux:   "dfbcffa1fa5acc1f8ff983b47a3617c8cdaa40c7a218ab8db24e4b165eeef431"
  end

  depends_on "cmake"
  depends_on "gmp"
  depends_on "llvm@14"
  depends_on "python@3.11"

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
    python = "python3.11"
    # It should be noted that this will expand to: 'for cmd in python3.11 python3 python python2; do'
    # in our find-python.sh script.
    inreplace "util/config/find-python.sh", /^(for cmd in )(python3 )/, "\\1#{python} \\2"

    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec
    ENV["CHPL_GMP"] = "system"
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
