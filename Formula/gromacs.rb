class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "https://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2020.5.tar.gz"
  sha256 "7b6aff647f7c8ee1bf12204d02cef7c55f44402a73195bd5f42cf11850616478"

  livecheck do
    url "https://ftp.gromacs.org/pub/gromacs/"
    regex(/href=.*?gromacs[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "649f05f376aa374b060807f2d6409c2d7e3ea4e96ec6736a0e8759446604597a" => :big_sur
    sha256 "695030d3fca2b654f2b1a9abcf5bcd0b29adc917d12633312bdfd201e8ea84d1" => :arm64_big_sur
    sha256 "14af8abdc37c7dfad95a33545c510244ec1af163fde27a96d21f5ac7256ae93a" => :catalina
    sha256 "d3da525c518fcf8401382ce76081a07de31f09b89ae9a6fc4d4f2807f9a6ea3b" => :mojave
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
