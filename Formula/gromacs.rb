class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "http://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2018.tar.gz"
  sha256 "deb5d0b749a52a0c6083367b5f50a99e08003208d81954fb49e7009e1b1fd0e9"

  bottle do
    rebuild 1
    sha256 "fbe26581c8430f11e653030247229c8fce9c0ab86e5d5d38f4829df2f165d676" => :high_sierra
    sha256 "89f40154abdee6cf57dd990b9aa61eb568a2e4dea7d590fea94993d1c52cfd0d" => :sierra
    sha256 "893b2625884d8c4215fbbe9ea279a10b2c8460cf505fe1c530fa5169e1788925" => :el_capitan
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
