class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "http://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2018.2.tar.gz"
  sha256 "ed2b8fdb28f6c3e84896e87e7bf534c21bb9d264fb40683cb17a8612d9a5ba80"

  bottle do
    sha256 "83d8187c1be30367ae0a40655a6da70b4190b6f5d8baad6e170db6a868bfdf4f" => :high_sierra
    sha256 "0eaccc6f5e50c3d41c96f29fba0452a69becada67142f83b21e2c30373c42e00" => :sierra
    sha256 "d820b8f64464e4557d042d3aea54effc952c99333b1f3ac376a3f9a9753b4aa4" => :el_capitan
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

    inreplace "scripts/CMakeLists.txt", "CMAKE_INSTALL_BINDIR",
                                        "CMAKE_INSTALL_DATADIR"

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
