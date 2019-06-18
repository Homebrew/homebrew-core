class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "http://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2019.3.tar.gz"
  sha256 "4211a598bf3b7aca2b14ad991448947da9032566f13239b1a05a2d4824357573"

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gcc@8" # Compilation using gcc 9.1 failed for some reason.

  def install
    # fix an error on detecting CPU. see https://redmine.gromacs.org/issues/2927
    inreplace "cmake/gmxDetectCpu.cmake",
              "\"${GCC_INLINE_ASM_DEFINE} -I${PROJECT_SOURCE_DIR}/src -DGMX_CPUINFO_STANDALONE ${GMX_STDLIB_CXX_FLAGS} -DGMX_TARGET_X86=${GMX_TARGET_X86_VALUE}\")",
              "${GCC_INLINE_ASM_DEFINE} -I${PROJECT_SOURCE_DIR}/src -DGMX_CPUINFO_STANDALONE ${GMX_STDLIB_CXX_FLAGS} -DGMX_TARGET_X86=${GMX_TARGET_X86_VALUE})"
    # Use gnu compiler to enable OpenMP instead of Apple llvm
    args = std_cmake_args + %w[
      -DCMAKE_C_COMPILER=gcc-8
      -DCMAKE_CXX_COMPILER=g++-8
      -DGMX_MPI=OFF
      -DGMX_DOUBLE=OFF
      -DGMX_OPENMP=ON
      -DGMX_GPU=OFF
      -DBUILD_SHARED_LIBS=ON
      -DGMX_PREFER_STATIC_LIBS=OFF
      -DGMX_FFT_LIBRARY=FFTW3
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
