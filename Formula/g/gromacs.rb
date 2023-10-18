class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "https://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2023.2.tar.gz"
  sha256 "bce1480727e4b2bb900413b75d99a3266f3507877da4f5b2d491df798f9fcdae"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://ftp.gromacs.org/pub/gromacs/"
    regex(/href=.*?gromacs[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f42ec1a9a186ba3799a329faa1a19db3f67a710716ce09e650d545a7984b4377"
    sha256 arm64_ventura:  "a7a0967a6a32d0aa14aab0c1f251f4d43e93b622b2540d216dd211735b627d5a"
    sha256 arm64_monterey: "a04ff3fc0d7685ae63927307fd07a2278c773c2d188789f33fdca1304b1697fd"
    sha256 arm64_big_sur:  "2f7fe800fe0ba5c7ef55fea32b81886db90669b7f472b3ea00f35f694d244baa"
    sha256 sonoma:         "29daebe74715bc4c4a6191e36ba63e8e81d08503915403537b00949a775eeb56"
    sha256 ventura:        "848e972271e7abee5c871be0fa2992bce4a881656a973171c080cd6812dea9e2"
    sha256 monterey:       "298f09d76f22b3f789c109b4a3e3882de841e363e4c4e15edd354444e073821a"
    sha256 big_sur:        "697398fc20ff1409331e83545e0a8f23c169b37fd8f40c161922922e119c8571"
    sha256 x86_64_linux:   "034d67c68d584f62172d189e5939bfcbcac352a3565cae4ca27bfe4bcc1cdf37"
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

    args = %W[
      -DGROMACS_CXX_COMPILER=#{cxx}
      -DGMX_VERSION_STRING_OF_FORK=#{tap.user}
      -DGMX_INSTALL_LEGACY_API=ON
    ]
    # Force SSE2/SSE4.1 for compatibility when building Intel bottles
    args << "-DGMX_SIMD=#{MacOS.version.requires_sse41? ? "SSE4.1" : "SSE2"}" if Hardware::CPU.intel? && build.bottle?
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
