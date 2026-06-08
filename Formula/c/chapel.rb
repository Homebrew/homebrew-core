class Chapel < Formula
  include Language::Python::Shebang

  desc "Programming language for productive parallel computing at scale"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/2.8.0/chapel-2.8.0.tar.gz"
  sha256 "80e8c3018e33e49674c7a2542e062547ea41d64d6595edb3b799e90c88f963f8"
  license "Apache-2.0"
  head "https://github.com/chapel-lang/chapel.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 arm64_tahoe:   "a73efe05b4551688355d1ddc3707424ae86573fc91352aec8c0eae6e0c4f6ce4"
    sha256 arm64_sequoia: "9dcd53c9c5b564dfe18e8adab1fcaa9bace0847b05e9a7e0895c9bc2118d0a72"
    sha256 arm64_sonoma:  "e1deda3af30cfb9d006072dd0b87bb57f76337d5819abad0076a0281495b5589"
    sha256 sonoma:        "8cdec547c132c71423804efa6c22c49dd802351b5e4984b8caa21ff09130e785"
    sha256 arm64_linux:   "2a8974a412dad807f368dc6ec6d0e81be099202c12536a741cd414752b864efb"
    sha256 x86_64_linux:  "69749327935b602942509d11a242e12641fb5d5c3692592cf7794d18519802ac"
  end

  depends_on "cmake"
  depends_on "gmp"
  depends_on "hwloc"
  depends_on "jemalloc"
  depends_on "llvm@21"
  depends_on "pkgconf"
  depends_on "python@3.14"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  # determine the C backend to use based on the system
  def cbackend
    on_macos do
      return "clang"
    end
    on_linux do
      return "gnu"
    end
  end

  def install
    # Always detect Python used as dependency rather than needing aliased Python formula
    python = "python3.14"
    # It should be noted that this will expand to: 'for cmd in python3.14 python3 python python2; do'
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

    # This ENV avoids issues with GASNet picking up the wrong linker
    ENV["CHPL_IGNORE_GASNET_LD"] = "1"

    # don't try to set CHPL_LLVM_GCC_PREFIX since the llvm
    # package should be configured to use a reasonable GCC
    (libexec/"chplconfig").write <<~EOS
      CHPL_RE2=bundled
      CHPL_GMP=system
      CHPL_TARGET_MEM=jemalloc
      CHPL_TARGET_JEMALLOC=system
      CHPL_HWLOC=system
      CHPL_LLVM=system
      CHPL_LLVM_CONFIG=#{llvm.opt_bin}/llvm-config
      CHPL_LLVM_GCC_PREFIX=none
      CHPL_RUNTIME_CPU=none
      CHPL_TARGET_CPU=native
    EOS

    if OS.linux?
      # we get strange build errors when trying to build with libunwind on linux
      # the bundled build gets weird linking errors. this seems to be the fault
      # of the homebrew build environment. we also cant use the system libunwind
      # due to it being keg-only and not found by default.
      # for now, disable stack unwinding with linuxbrew
      (libexec/"chplconfig").append_lines <<~EOS
        CHPL_UNWIND=none
      EOS
    end

    # Must be built from within CHPL_HOME to prevent build bugs.
    # https://github.com/Homebrew/legacy-homebrew/pull/35166
    cd libexec do
      system "./util/printchplenv", "--all"
      system "make"
      with_env(CHPL_TARGET_COMPILER: cbackend) do
        system "make"
      end
      with_env(
        CHPL_COMM:               "gasnet",
        CHPL_COMM_SUBSTRATE:     "udp",
        CHPL_GASNET_CFG_OPTIONS: "--disable-auto-conduit-detect --enable-udp",
      ) do
        system "make"
        # C backend requires https://github.com/chapel-lang/chapel/pull/27652
        # to be resolved
        # with_env(CHPL_TARGET_COMPILER: cbackend) do
        #   system "make"
        # end
      end
      with_env(CHPL_LOCALE_MODEL: "gpu", CHPL_GPU: "cpu") do
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

      #
      # the following makes sure GASNet doesn't pickup incorrect paths during the build
      #
      # clobber the gasnet include
      rm_r Dir.glob("third-party/gasnet/install/**/include")
      # clobber GASNET_CC=, GASNET_CXX=, and GASNET_LD= from the *.pc files
      gasnet_pc_files = Dir.glob("third-party/gasnet/install/**/lib/pkgconfig/gasnet-*-par.pc")
      gasnet_pc_files.each do |pc_file|
        inreplace pc_file, /^GASNET_CC=.*$/, ""
        inreplace pc_file, /^GASNET_CXX=.*$/, ""
        inreplace pc_file, /^GASNET_LD=.*$/, ""
      end
      # remove the gasnet_tools-par.pc files
      rm_r Dir.glob("third-party/gasnet/install/**/lib/pkgconfig/gasnet_tools-par.pc")
    end

    # Install chpl and other binaries (e.g. chpldoc) into bin/ as exec scripts.
    platform = if OS.linux? && Hardware::CPU.is_64_bit?
      "linux64-#{Hardware::CPU.arm? ? "aarch64" : Hardware::CPU.arch}"
    else
      "#{OS.kernel_name.downcase}-#{Hardware::CPU.arch}"
    end

    bin.install libexec.glob("bin/#{platform}/*")
    bin.env_script_all_files libexec/"bin"/platform, CHPL_HOME: libexec, CHPL_IGNORE_GASNET_LD: 1
    man1.install_symlink libexec.glob("man/man1/*.1")
    (lib/"cmake/chpl").install libexec.glob("lib/cmake/chpl/*")

    chplrun_udp = libexec/"bin"/platform/"chplrun-udp"
    chplrun_udp.write <<~EOS
      #!/bin/bash
      GASNET_SPAWNFN=L \
      GASNET_ROUTE_OUTPUT=0 \
      GASNET_QUIET=Y \
      GASNET_MASTERIP=127.0.0.1 \
      GASNET_WORKERIP=127.0.0.0 \
      CHPL_RT_OVERSUBSCRIBED=yes \
      exec "$@"
    EOS
    chplrun_udp.chmod 0755
    bin.install_symlink chplrun_udp => "chplrun-udp"
  end

  def caveats
    <<~EOS
      By default, compiled Chapel programs will be single-locale only.
      To compile and run multi-locale Chapel programs locally:

      Compile your program with:
        `chpl --comm=gasnet --comm-substrate=udp`
      And then run it with:
        `chplrun-udp ./your_program_name`

      To simulate GPU execution, you can compile your program with:
        `chpl --locale-model=gpu --gpu=cpu`
    EOS
  end

  test do
    ENV["CHPL_HOME"] = libexec
    ENV["CHPL_INCLUDE_PATH"] = HOMEBREW_PREFIX/"include"
    ENV["CHPL_LIB_PATH"] = HOMEBREW_PREFIX/"lib"
    ENV["CHPL_IGNORE_GASNET_LD"] = "1"
    ENV["CHPL_RT_SILENCE_UNUSED_CORES"] = "1"

    cd libexec do
      system "util/test/checkChplInstall"
      system "util/test/checkChplDoc"
      with_env(CHPL_TARGET_COMPILER: cbackend) do
        system "util/test/checkChplInstall"
      end
      with_env(CHPL_COMM: "gasnet", CHPL_COMM_SUBSTRATE: "udp") do
        with_env(
          GASNET_SPAWNFN:         "L",
          GASNET_ROUTE_OUTPUT:    "0",
          GASNET_QUIET:           "Y",
          GASNET_MASTERIP:        "127.0.0.1",
          GASNET_WORKERIP:        "127.0.0.0",
          CHPL_RT_OVERSUBSCRIBED: "yes",
        ) do
          system "util/test/checkChplInstall"
          # C backend requires https://github.com/chapel-lang/chapel/pull/27652
          # to be resolved
          # with_env(CHPL_TARGET_COMPILER: cbackend) do
          #   system "util/test/checkChplInstall"
          # end
        end
      end
      with_env(CHPL_LOCALE_MODEL: "gpu", CHPL_GPU: "cpu") do
        system "util/test/checkChplInstall"
      end
    end
    system bin/"chpl", "--print-passes", "--print-commands", libexec/"examples/hello.chpl"
    system bin/"chpl", "--target-compiler", cbackend, "--print-passes",
           "--print-commands", libexec/"examples/hello.chpl"
    system bin/"chpldoc", "--version"
    system bin/"mason", "--version"

    # Test chplcheck, if it works CLS probably does too.
    # chpl-language-server will hang indefinitely waiting for a LSP client
    system bin/"chplcheck", "--list-rules"
    system bin/"chplcheck", libexec/"examples/hello.chpl"
  end
end
