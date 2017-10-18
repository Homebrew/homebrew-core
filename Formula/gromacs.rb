class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "http://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2016.3.tar.gz"
  sha256 "7bf00e74a9d38b7cef9356141d20e4ba9387289cbbfd4d11be479ef932d77d27"

  bottle do
    sha256 "d3cb6d19f2f26d259bb717b3575cf514f7bade230531b11ec0d1d21b4d9dd676" => :high_sierra
    sha256 "90faa8b279f78823dae87bea50c3f1e88f9ede89678fb3f1711f643f576359a1" => :sierra
    sha256 "10f94061644f511939db8cc4d4c06ee767901c7aebd54c95872cc547b85826f7" => :el_capitan
    sha256 "3b93cbd26c93a4abb5401b7d87bfc8cb27d4b9641acecf47c26675f0fbd0f8e6" => :yosemite
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
