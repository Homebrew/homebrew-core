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
    sha256 "1bcecb34934eadf23261f044280b1794a4a99cdd6b65f85e741a16b86b3b5d34" => :big_sur
    sha256 "e2228179c68b5e529ed52b1c254d1c7413a3a024008a269ab011e39df564e146" => :arm64_big_sur
    sha256 "a47955588b6626afba661dd5a72b7b2e4669f28e59060ebfd9e033f2739ba56e" => :catalina
    sha256 "3741e067b76102f12bd52d2a9f5cfb5ff2a437f60c09788f8a4cd2b066966cf9" => :mojave
    sha256 "931193676d571f0418f11bf67885b2a0d0f5c94ce0e6f2bcd7f6f5910ec5ebd1" => :high_sierra
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
