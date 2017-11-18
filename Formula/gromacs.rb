class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "http://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2016.4.tar.gz"
  sha256 "4be9d3bfda0bdf3b5c53041e0b8344f7d22b75128759d9bfa9442fe65c289264"

  bottle do
    sha256 "eb7f67951a1d269c87643441f92218a5f2ee670b0aca2aa1a554419bab36270a" => :high_sierra
    sha256 "fe04d6ed6aa2992f13a8d7bd7b027313226034c7536dd0586875bbd1fb8babd3" => :sierra
    sha256 "2c48ca08b9feaeb46d2becae8c19eace53dd68bbf7b9628ece2aff4b1020e168" => :el_capitan
  end

  option "with-double", "Enables double precision"

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gsl"
  depends_on :mpi => :optional
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
