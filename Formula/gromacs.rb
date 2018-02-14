class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "http://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2018.tar.gz"
  sha256 "deb5d0b749a52a0c6083367b5f50a99e08003208d81954fb49e7009e1b1fd0e9"

  bottle do
    sha256 "c9a80ad8b736c718b8dad61a2150239cf362f471e5651e31e29f9c7eac50698c" => :high_sierra
    sha256 "f2591692c45ce6f2b584eb62c113e72143c1930276b9cdcfa5072f191add99f9" => :sierra
    sha256 "2da1f5cc720905623d23591b30adf60a1c78bb09b25735949dfd2c426dac287f" => :el_capitan
  end

  option "with-double", "Enables double precision"
  option "with-mpi", "Enable parallel support"

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gsl"
  depends_on "open-mpi" if build.with? "mpi"
  depends_on :x11 => :optional

  def install
    args = std_cmake_args + %w[-DGMX_GSL=ON]
    args << "-DGMX_DOUBLE=ON" if build.include? "enable-double"
    args << "-DGMX_MPI=ON" if build.with? "mpi"
    args << "-DGMX_X11=ON" if build.with? "x11"

    inreplace "scripts/CMakeLists.txt", "BIN_INSTALL_DIR", "DATA_INSTALL_DIR"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      ENV.deparallelize { system "make", "install" }
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
