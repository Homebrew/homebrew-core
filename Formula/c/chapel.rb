class Chapel < Formula
  desc "Programming language for productive parallel computing at scale"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/2.0.0/chapel-2.0.0.tar.gz"
  sha256 "b5387e9d37b214328f422961e2249f2687453c2702b2633b7d6a678e544b9a02"
  license "Apache-2.0"
  head "https://github.com/chapel-lang/chapel.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "e7ea9cadf5ba880d79b9aee5e82756faae156717bf4fcbf08edf2a6730beef78"
    sha256 arm64_ventura:  "e7f3fa3355572f34be363ba6ad9832770e88326f598dd017e8b270e79499a5b1"
    sha256 arm64_monterey: "96f19eb98b6323aa5405722ff4460ef41a287ae579656cacfebad903bf596413"
    sha256 sonoma:         "49cfd27778bdf6d3e994a1ec7e343ef8893feb4b7c13043437f44f534b819e60"
    sha256 ventura:        "1dc143ee5c62f2df2a62eaf4b0664489860790f68bec53b145ed35d0e14b7d31"
    sha256 monterey:       "a5d7b507a654b3b40ffe22254e7c925a6aab5f740b9b66ab6dcc51d4d41f8daa"
    sha256 x86_64_linux:   "eca86d0e17808b7e346ea8edbb5d95ec917b347e25f67bdf8fe27037b6b21914"
  end

  depends_on "cmake"
  depends_on "gmp"
  depends_on "llvm"
  depends_on "python@3.11"

  # LLVM is built with gcc11 and we will fail on linux with gcc version 5.xx
  fails_with gcc: "5"

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
      CHPL_MEM=cstdlib
      CHPL_TASKS=fifo
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
      # TODO: a bug (in the formula?) is causing chpldoc to not be installed
      # see https://github.com/chapel-lang/chapel/issues/24639
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
        # TODO: enable when bug affecting chpldoc install is resolved
        # system "util/test/checkChplDoc"
      end
      with_env(CHPL_LLVM: "none") do
        system "util/test/checkChplInstall"
        # TODO: enable when bug affecting chpldoc install is resolved
        # system "util/test/checkChplDoc"
      end
    end
    system bin/"chpl", "--print-passes", "--print-commands", libexec/"examples/hello.chpl"
    system bin/"mason", "--version"
  end
end
