class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "http://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2018.1.tar.gz"
  sha256 "4d3533340499323fece83b4a2d4251fa856376f2426c541e00b8e6b4c0d705cd"

  bottle do
    sha256 "87af5516efcdf5abf238d36f13060649e767a1e729095daa534760f49deb12dc" => :high_sierra
    sha256 "b0645796ec3a3362a9e81de36b193c1e265d099ae496e1d74b32b4f4b1e02c8f" => :sierra
    sha256 "0d59a8c98be5188486cd1738fee23ed5461edee59a26715af50cda323ab83659" => :el_capitan
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
