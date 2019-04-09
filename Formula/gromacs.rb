class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "http://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2019.1.tar.gz"
  sha256 "b2c37ed2fcd0e64c4efcabdc8ee581143986527192e6e647a197c76d9c4583ec"

  bottle do
    sha256 "94d33c3b2aab69176bb9ae38225a4486f8e648e775628046cc376d6110f70c64" => :mojave
    sha256 "f5e98222c231b867623809636fe56ec550bf533f517b7312bb554a915bdf4fe9" => :high_sierra
    sha256 "c4479eb9a92d1615c2247c9ba3ab185de46a35cc37b55c2a6443f0f73eb7c0cb" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gsl"

  def install
    inreplace "scripts/CMakeLists.txt", "CMAKE_INSTALL_BINDIR",
                                        "CMAKE_INSTALL_DATADIR"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DGMX_GSL=ON"
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
