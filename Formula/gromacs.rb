class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "http://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2019.3.tar.gz"
  sha256 "4211a598bf3b7aca2b14ad991448947da9032566f13239b1a05a2d4824357573"

  bottle do
    sha256 "6b5ebbac12d72bce693c4fa1c424cdc884afefa4ba11264922be52c2974f69fe" => :catalina
    sha256 "6f423386809bbdb219b41c619b8a7b241e36e7a4881c155cd6deecb78fe2edfa" => :mojave
    sha256 "582b641126dcc98177587a85a0a75d953c51ae981976a895e243b33fe6e3e089" => :high_sierra
    sha256 "08c431f5f67fe71aaf24fdd501ba0d6e2816b273b18a08fa00079a0eeac6d948" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gcc" # for OpenMP

  def install
    # Non-executable GMXRC files should be installed in DATADIR
    inreplace "scripts/CMakeLists.txt", "CMAKE_INSTALL_BINDIR",
                                        "CMAKE_INSTALL_DATADIR"
    # fix an error on detecting CPU. see https://redmine.gromacs.org/issues/2927
    inreplace "cmake/gmxDetectCpu.cmake",
              "\"${GCC_INLINE_ASM_DEFINE} -I${PROJECT_SOURCE_DIR}/src -DGMX_CPUINFO_STANDALONE ${GMX_STDLIB_CXX_FLAGS} -DGMX_TARGET_X86=${GMX_TARGET_X86_VALUE}\")",
              "${GCC_INLINE_ASM_DEFINE} -I${PROJECT_SOURCE_DIR}/src -DGMX_CPUINFO_STANDALONE ${GMX_STDLIB_CXX_FLAGS} -DGMX_TARGET_X86=${GMX_TARGET_X86_VALUE})"

    args = std_cmake_args + %w[
      -DCMAKE_C_COMPILER=gcc-9
      -DCMAKE_CXX_COMPILER=g++-9
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    bash_completion.install "build/scripts/GMXRC" => "gromacs-completion.bash"
    bash_completion.install "#{bin}/gmx-completion-gmx.bash" => "gmx-completion-gmx.bash"
    bash_completion.install "#{bin}/gmx-completion.bash" => "gmx-completion.bash"
    zsh_completion.install "build/scripts/GMXRC.zsh" => "_gromacs"
  end

  def caveats; <<~EOS
    GMXRC and other scripts installed to:
      #{HOMEBREW_PREFIX}/share/gromacs
  EOS
  end

  test do
    system "#{bin}/gmx", "help"
  end
end
