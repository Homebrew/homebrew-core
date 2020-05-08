class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "http://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2020.2.tar.gz"
  sha256 "7465e4cd616359d84489d919ec9e4b1aaf51f0a4296e693c249e83411b7bd2f3"
  revision 1

  bottle do
    sha256 "1d66612a7301aaf5ef4de6e75c3c3946795f08b2dc37007ac898ad1e9f22fc14" => :catalina
    sha256 "0423b519282cdeb36dc7be9f7721534ac9f31c800fc8c425f054cb62611ddeb2" => :mojave
    sha256 "eb63d5a06524bb0cce1ba1178b60030f8c61b50480104801c61bb6e2db5a5acb" => :high_sierra
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

    args = std_cmake_args + %W[
      -DCMAKE_C_COMPILER=gcc-#{Formula["gcc"].version_suffix}
      -DCMAKE_CXX_COMPILER=g++-#{Formula["gcc"].version_suffix}
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
