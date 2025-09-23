class Chapel < Formula
  include Language::Python::Shebang

  desc "Programming language for productive parallel computing at scale"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/2.5.0/chapel-2.5.0.tar.gz"
  sha256 "020220ca9bf52b9f416e9a029bdc465bb1f635c1e274c6ca3c18d1f83e41fce1"
  license "Apache-2.0"
  revision 1
  head "https://github.com/chapel-lang/chapel.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 arm64_sequoia: "c240bd5999904238afbe1c5c337c730b42d30912c029e87febdb819d4d165ad0"
    sha256 arm64_sonoma:  "96d857a9f7ae365f1ff09e228921ee8cab38ad5543a03ebbba87588bae914416"
    sha256 arm64_ventura: "191d300a56ed3ab0fdea1471b0cd219f1c9d03466a312515a02a8f6091830bd9"
    sha256 sonoma:        "ae4692a15c2ef296206e6dbc9130a95905aeae1cb2729f730e252b1953974dcf"
    sha256 ventura:       "1549c04130d6700f3bc3371940c21a326dd3627802d9d24e8e0f6b349424aaa1"
    sha256 arm64_linux:   "aae1218cbf6324e4f65d4ed4be62add0bed2ac45187e5fe6f27fc4dbe5e1905f"
    sha256 x86_64_linux:  "9e343ae0af8a7173e152e84f154d30812840e88008bf9781ada2428f4a902150"
  end

  depends_on "cmake"
  depends_on "gmp"
  depends_on "hwloc"
  depends_on "jemalloc"
  depends_on "llvm@20"
  depends_on "pkgconf"
  depends_on "python@3.13"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    # Always detect Python used as dependency rather than needing aliased Python formula
    python = "python3.13"
    # It should be noted that this will expand to: 'for cmd in python3.13 python3 python python2; do'
    # in our find-python.sh script.
    inreplace "util/config/find-python.sh", /^(for cmd in )(python3 )/, "\\1#{python} \\2"

    # a lot of scripts have a python3 or python shebang, which does not point to python3.12 anymore
    Pathname.glob("**/*.py") do |pyfile|
      rewrite_shebang detected_python_shebang, pyfile
    end

    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec
    ENV["CHPL_GMP"] = "system"
    # This ENV avoids a problem where cmake cache is invalidated by subsequent make calls
    ENV["CHPL_CMAKE_USE_CC_CXX"] = "1"
    ENV["CHPL_CMAKE_PYTHON"] = python

    # don't try to set CHPL_LLVM_GCC_PREFIX since the llvm
    # package should be configured to use a reasonable GCC
    (libexec/"chplconfig").write <<~EOS
      CHPL_RE2=bundled
      CHPL_GMP=system
      CHPL_TARGET_MEM=jemalloc
      CHPL_TARGET_JEMALLOC=system
      CHPL_HWLOC=system
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
        system "make"
      end
      with_env(CHPL_PIP_FROM_SOURCE: "1") do
        system "make", "chpldoc"
        system "make", "chplcheck"
        system "make", "chpl-language-server"
      end
      system "make", "mason"
      system "make", "cleanall"

      rm_r("third-party/llvm/llvm-src/")
      rm_r("third-party/gasnet/gasnet-src/")
      rm_r("third-party/libfabric/libfabric-src/")
      rm_r("third-party/libunwind/libunwind-src/")
      rm_r("third-party/gmp/gmp-src/")
      rm_r("third-party/qthread/qthread-src/")
    end

    # Install chpl and other binaries (e.g. chpldoc) into bin/ as exec scripts.
    platform = if OS.linux? && Hardware::CPU.is_64_bit?
      "linux64-#{Hardware::CPU.arm? ? "aarch64" : Hardware::CPU.arch}"
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

    # Test chplcheck, if it works CLS probably does too.
    # chpl-language-server will hang indefinitely waiting for a LSP client
    system bin/"chplcheck", "--list-rules"
    system bin/"chplcheck", libexec/"examples/hello.chpl"
  end
end
