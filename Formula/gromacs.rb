class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "http://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2020.1.tar.gz"
  sha256 "e1666558831a3951c02b81000842223698016922806a8ce152e8f616e29899cf"

  bottle do
    sha256 "72d49c0e34e42499f3f415d2eb0945a6a92446237b7175b385e546c3534e5b98" => :catalina
    sha256 "bfab3f87481535fbfbfb6c03b22b0ffd27ebebf98fef1b3dba88fe5d36394f1d" => :mojave
    sha256 "159631826837201f2d33cd1e6b018928c5e2fe82a3973439ed9e62a4f461da6e" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
  depends_on "openblas"

  def install
    # Non-executable GMXRC files should be installed in DATADIR
    inreplace "scripts/CMakeLists.txt", "CMAKE_INSTALL_BINDIR",
                                        "CMAKE_INSTALL_DATADIR"

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
