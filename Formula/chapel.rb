class Chapel < Formula
  desc "Programming language for productive parallel computing at scale"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.25.1/chapel-1.25.1.tar.gz"
  sha256 "0c13d7da5892d0b6642267af605d808eb7dd5d4970766f262f38b94fa2405113"
  license "Apache-2.0"

  bottle do
    sha256 monterey:     "91ee14fe8cdb2e5de1bcd0f84cb159a79ff5cfb310644ec427aca1e992c53301"
    sha256 big_sur:      "71be5aaea9c567fd89e7cd0943aa6658200ce880da493f3269221745365d2f4f"
    sha256 catalina:     "b50729e75a45fdc2b4b350951d82c52b5abeb26813cf5fc6289a01dcde6afbae"
    sha256 mojave:       "486ff899300cc9ca346603badc31e7812f0ece757c60ae878588068ee7738023"
    sha256 x86_64_linux: "7cf01213c80d41ed1b20451fd9f11b4b651a1b9a603729826a383e73475918b3"
  end

  depends_on "gmp"
  depends_on "llvm@11"
  depends_on "python@3.9"

  patch :p0, :DATA do
    url "https://github.com/chapel-lang/chapel/commit/acc2a62d0446f6e56fbd6b73db42f9ec025dacac"
    sha256 "33fa2d0bf963517e330916f334482ec3132df1907034fbb06a7aeec70989c058"
  end

  def install
    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec
    # This is for mason
    ENV["CHPL_RE2"] = "bundled"
    ENV["CHPL_GMP"] = "system"
    ENV["CHPL_INCLUDE_PATH"] = HOMEBREW_PREFIX/"include"
    ENV["CHPL_LIB_PATH"] = HOMEBREW_PREFIX/"lib"
    ENV["CHPL_LLVM_CONFIG"] = HOMEBREW_PREFIX/"opt/llvm@11/bin/llvm-config"

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
      system "make", "chpldoc"
      system "make", "mason"
      system "make", "cleanall"
      rm_rf("third-party/llvm/llvm-src/")
      rm_rf("third-party/gasnet/gasnet-src")
      rm_rf("third-party/libfabric/libfabric-src")
      rm_rf("third-party/fltk/fltk-1.3.5-source.tar.gz")
      rm_rf("third-party/libunwind/libunwind-1.1.tar.gz")
      rm_rf("third-party/gmp/gmp-src/")
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
    ENV["CHPL_GMP"] = "system"
    ENV["CHPL_INCLUDE_PATH"] = HOMEBREW_PREFIX/"include"
    ENV["CHPL_LIB_PATH"] = HOMEBREW_PREFIX/"lib"
    ENV["CHPL_LLVM_CONFIG"] = HOMEBREW_PREFIX/"opt/llvm@11/bin/llvm-config"
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
