class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "https://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2022.tar.gz"
  sha256 "fad60d606c02e6164018692c6c9f2c159a9130c2bf32e8c5f4f1b6ba2dda2b68"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://ftp.gromacs.org/pub/gromacs/"
    regex(/href=.*?gromacs[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "29d1a7cab3e8920cc02d1bc88d8541f8766abd9bb80a6ddb0819dab9580864c1"
    sha256 arm64_big_sur:  "0d9dc48b1a99c937d9e8098c50a519a11e89c79079c5dfa5d5e27ec3c5ecc27e"
    sha256 monterey:       "30b91d9b0b975fae0a4e368db51f3ca5e35f014703a5b4106b4d60afe36af2e4"
    sha256 big_sur:        "e21332f62443344a4ab804d2a07834c701f7d4a28fffe949d97e73942740c240"
    sha256 catalina:       "a954a737e2b29d9284145da3f12e0cc5863d821c050bf66681770ed92219f50f"
    sha256 x86_64_linux:   "a90670abac029ad4abbf449d0b134ff8dfa8ba9aceb85cafb2d18812d6bee0c4"
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
  depends_on "openblas"

  fails_with :clang
  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    # Non-executable GMXRC files should be installed in DATADIR
    inreplace "scripts/CMakeLists.txt", "CMAKE_INSTALL_BINDIR",
                                        "CMAKE_INSTALL_DATADIR"

    # Avoid superenv shim reference
    gcc = Formula["gcc"]
    cc = gcc.opt_bin/"gcc-#{gcc.any_installed_version.major}"
    cxx = gcc.opt_bin/"g++-#{gcc.any_installed_version.major}"
    inreplace "src/gromacs/gromacs-hints.in.cmake" do |s|
      s.gsub! "@CMAKE_LINKER@", "/usr/bin/ld"
      s.gsub! "@CMAKE_C_COMPILER@", cc
      s.gsub! "@CMAKE_CXX_COMPILER@", cxx
    end

    inreplace "src/buildinfo.h.cmakein" do |s|
      s.gsub! "@BUILD_C_COMPILER@", cc
      s.gsub! "@BUILD_CXX_COMPILER@", cxx
    end

    inreplace "src/gromacs/gromacs-config.cmake.cmakein", "@GROMACS_CXX_COMPILER@", cxx

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DGROMACS_CXX_COMPILER=#{cxx}",
                                             "-DGMX_VERSION_STRING_OF_FORK=#{tap.user}"
      system "make", "install"
    end

    bash_completion.install "build/scripts/GMXRC" => "gromacs-completion.bash"
    bash_completion.install bin/"gmx-completion-gmx.bash" => "gmx-completion-gmx.bash"
    bash_completion.install bin/"gmx-completion.bash" => "gmx-completion.bash"
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
