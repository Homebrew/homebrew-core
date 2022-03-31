class Chapel < Formula
  desc "Programming language for productive parallel computing at scale"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.26.0/chapel-1.26.0.tar.gz"
  sha256 "ba396b581f0a17f8da3f365a3f8b079b8d2e229a393fbd1756966b0019931ece"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "229f22e29b0cc7a904841636c924d0c94c00299f817ed294247957d43c128cf3"
    sha256 arm64_big_sur:  "9f4a5b7644f18da492f75b4442bc7e22d0b59fa72d6952b15f14f15a2949f57b"
    sha256 monterey:       "bd3d8c066ce51d66b44e0430fc12f01ce5b99701f337304bf609b185bdbdefec"
    sha256 big_sur:        "20b698193b5f7efb99c0eee60126a3e47a420fe99a65ed83aba919fac1cfacac"
    sha256 catalina:       "8eeb73c3884680831146792096af481b1f2c23902eed1ad798f3aa890d2a1e49"
    sha256 x86_64_linux:   "f351e793925739313b0025b6e90287688da278ebe60191000b5a6e5e239b60ef"
  end

  depends_on "gmp"
  depends_on "python@3.10"
  on_macos do
    depends_on "llvm" if MacOS.version > :catalina
    depends_on "llvm@11" if MacOS.version <= :catalina
  end
  on_linux do
    depends_on "llvm"
  end

  # LLVM is built with gcc11 and we will fail on linux with gcc version 5.xx
  fails_with gcc: "5"

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
      (libexec/"chplconfig").write <<~EOS
        CHPL_RE2=bundled
        CHPL_GMP=system
      EOS

      if OS.mac?
        if MacOS.version > :catalina
          system "echo CHPL_LLVM_CONFIG=#{HOMEBREW_PREFIX}/opt/llvm@13/bin/llvm-config >> chplconfig"
        else
          system "echo CHPL_LLVM_CONFIG=#{HOMEBREW_PREFIX}/opt/llvm@11/bin/llvm-config >> chplconfig"
        end
      else
        system "echo CHPL_LLVM_CONFIG=#{HOMEBREW_PREFIX}/opt/llvm@13/bin/llvm-config >> chplconfig"
      end

      # don't try to set CHPL_LLVM_GCC_PREFIX since the llvm@13
      # package should be configured to use a reasonable GCC
      system 'echo CHPL_LLVM_GCC_PREFIX="none" >> chplconfig'
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
