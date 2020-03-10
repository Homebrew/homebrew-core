class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "http://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2020.1.tar.gz"
  sha256 "e1666558831a3951c02b81000842223698016922806a8ce152e8f616e29899cf"

  bottle do
    sha256 "6b5ebbac12d72bce693c4fa1c424cdc884afefa4ba11264922be52c2974f69fe" => :catalina
    sha256 "6f423386809bbdb219b41c619b8a7b241e36e7a4881c155cd6deecb78fe2edfa" => :mojave
    sha256 "582b641126dcc98177587a85a0a75d953c51ae981976a895e243b33fe6e3e089" => :high_sierra
    sha256 "08c431f5f67fe71aaf24fdd501ba0d6e2816b273b18a08fa00079a0eeac6d948" => :sierra
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
