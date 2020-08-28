class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "http://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2020.3.tar.gz"
  sha256 "903183691132db14e55b011305db4b6f4901cc4912d2c56c131edfef18cc92a9"

  livecheck do
    url "https://ftp.gromacs.org/pub/gromacs/"
    regex(/href=.*?gromacs[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "88bd44a6a167f4f2acc57dc9cb9eff739131cd1249da2e390ebbb51e0b28e18d" => :catalina
    sha256 "d2b0f9fc2b1a360ee1e9786a54ac1815f450479173c497a3993719d4878ca7e8" => :mojave
    sha256 "b9243cffdace751366a94db0fbee1c19db7c7aa2637268d95dbae8915bd167ff" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
  depends_on "openblas"

  def install
    # Non-executable GMXRC files should be installed in DATADIR
    inreplace "scripts/CMakeLists.txt", "CMAKE_INSTALL_BINDIR",
                                        "CMAKE_INSTALL_DATADIR"

    # Avoid superenv shim reference
    inreplace "src/gromacs/gromacs-toolchain.cmake.cmakein", "@CMAKE_LINKER@",
                                                             "/usr/bin/ld"

    gcc_major_ver = Formula["gcc"].any_installed_version.major
    args = std_cmake_args + %W[
      -DCMAKE_C_COMPILER=gcc-#{gcc_major_ver}
      -DCMAKE_CXX_COMPILER=g++-#{gcc_major_ver}
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

  def caveats
    <<~EOS
      GMXRC and other scripts installed to:
        #{HOMEBREW_PREFIX}/share/gromacs
    EOS
  end

  test do
    system "#{bin}/gmx", "help"
  end
end
