class Chapel < Formula
  desc "Programming language for productive parallel computing at scale"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/2.0.1/chapel-2.0.1.tar.gz"
  sha256 "19ebcd88d829712468cfef10c634c3e975acdf78dd1a57671d11657574636053"
  license "Apache-2.0"
  head "https://github.com/chapel-lang/chapel.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "e75b261ff8378a1a86db49794ca9cc4419d8eadc7e7a4ce9a17430a5757bb778"
    sha256 arm64_ventura:  "7ff7abdf3c8301727e52d65b15837b8974d7d3be52bcac72601b181bf426e444"
    sha256 arm64_monterey: "a11ed899b3ccf9d8eac11910226d1f86a39f19a7d07c5e8d3f35d5785089eebc"
    sha256 sonoma:         "e5edf9340b6bfb94bcf39f930406db9db9b2801dd378da85e489a6bd78a676b2"
    sha256 ventura:        "ad9c9e354207c9926d25f513c1a3b7b6db0936dc1e27998f5859dd4d9cc7155b"
    sha256 monterey:       "cbc79ae37aa099e744ff21b5654d7fdb364c012a02eb27a0e5d73e0783c2a999"
    sha256 x86_64_linux:   "961ad1d420eeeac018098fba19f05ff207edcd279b8c98d5439838d9928f61de"
  end

  depends_on "cmake"
  depends_on "gmp"
  depends_on "llvm@17"
  depends_on "python@3.12"

  # LLVM is built with gcc11 and we will fail on linux with gcc version 5.xx
  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  # Fixes: SyntaxWarning: invalid escape sequence '\d'
  # Remove when merged: https://github.com/chapel-lang/chapel/pull/24643
  patch :DATA

  def install
    # Always detect Python used as dependency rather than needing aliased Python formula
    python = "python3.12"
    # It should be noted that this will expand to: 'for cmd in python3.12 python3 python python2; do'
    # in our find-python.sh script.
    inreplace "util/config/find-python.sh", /^(for cmd in )(python3 )/, "\\1#{python} \\2"

    # TEMPORARY adds clean-cmakecache target to prevent issues where only
    #           the first make target gets written to the proper CMAKE_RUNTIME_OUTPUT_DIRECTORY
    #           cmake detects a change in compilers (although the values are the same?) and
    #           reruns configure, losing the output directory we set at configure time
    inreplace "compiler/Makefile",
              "all: $(PRETARGETS) $(MAKEALLSUBDIRS) echocompilerdir $(TARGETS)\n",
              "all: $(PRETARGETS) $(MAKEALLSUBDIRS) echocompilerdir $(TARGETS)\n\n
              clean-cmakecache: FORCE\n\trm -f $(COMPILER_BUILD)/CMakeCache.txt\n\n"

    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec
    ENV["CHPL_GMP"] = "system"
    # don't try to set CHPL_LLVM_GCC_PREFIX since the llvm
    # package should be configured to use a reasonable GCC
    (libexec/"chplconfig").write <<~EOS
      CHPL_RE2=bundled
      CHPL_GMP=system
      CHPL_MEM=cstdlib
      CHPL_TASKS=fifo
      CHPL_LLVM_CONFIG=#{llvm.opt_bin}/llvm-config
      CHPL_LLVM_GCC_PREFIX=none
    EOS

    # Must be built from within CHPL_HOME to prevent build bugs.
    # https://github.com/Homebrew/legacy-homebrew/pull/35166
    cd libexec do
      system "./util/printchplenv", "--all"
      with_env(CHPL_LLVM: "none") do
        system "make"
      end
      with_env(CHPL_LLVM: "system") do
        cd "compiler" do
          system "make", "clean-cmakecache"
        end
        system "make"
      end
      with_env(CHPL_PIP_FROM_SOURCE: "1") do
        cd "compiler" do
          system "make", "clean-cmakecache"
        end
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
        system "util/test/checkChplDoc"
      end
      with_env(CHPL_LLVM: "none") do
        system "util/test/checkChplInstall"
        system "util/test/checkChplDoc"
      end
    end
    system bin/"chpl", "--print-passes", "--print-commands", libexec/"examples/hello.chpl"
    system bin/"chpldoc", "--version"
    system bin/"mason", "--version"
  end
end

__END__
diff --git a/util/chplenv/compiler_utils.py b/util/chplenv/compiler_utils.py
index c4d683830f4c..1d1be1d55521 100644
--- a/util/chplenv/compiler_utils.py
+++ b/util/chplenv/compiler_utils.py
@@ -32,7 +32,7 @@ def CompVersion(version_string):
     are not specified, 0 will be used for their value(s)
     """
     CompVersionT = namedtuple('CompVersion', ['major', 'minor', 'revision', 'build'])
-    match = re.search(u'(\d+)(\.(\d+))?(\.(\d+))?(\.(\d+))?', version_string)
+    match = re.search(u"(\\d+)(\\.(\\d+))?(\\.(\\d+))?(\\.(\\d+))?", version_string)
     if match:
         major    = int(match.group(1))
         minor    = int(match.group(3) or 0)
