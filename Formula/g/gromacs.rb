class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "https://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2026.4.tar.gz"
  sha256 "58eda60979b124fcf9dff8b1b63cedfbc72fdb36d99e921dc1bdc310571098b6"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url "https://ftp.gromacs.org/pub/gromacs/"
    regex(/href=.*?gromacs[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256               arm64_golden_gate: "5affba3979351ffa97c3ddf146a80674cf4291cefbf66937ab5d4fca9e8ec352"
    sha256               arm64_tahoe:       "dcec9b86ecc7c34bdc5692506283e9edfc6517611e2e1b3dcad8c70cb30e8fdb"
    sha256               arm64_sequoia:     "d836f7818ebbb58f8ac48c8f37087a7a60bf8a7e620ff9eb9d7b59015bea8fb5"
    sha256               arm64_linux:       "cfda23ff93f5a6bd6238e4cee31dae4c236f85e965911dac94bfd9b9d3cbe635"
    sha256 cellar: :any, x86_64_linux:      "8709ec05de0f35d03dda35872516eb0db384abc024d514223514b5beefbd02fb"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "lmfit"
  depends_on "muparser"
  depends_on "openblas"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Non-executable GMXRC files should be installed in DATADIR
    inreplace "scripts/CMakeLists.txt", "CMAKE_INSTALL_BINDIR",
                                        "CMAKE_INSTALL_DATADIR"
    # Completion workaround
    inreplace "scripts/GMXRC.bash.cmakein", "$GMXBIN/gmx-completion", bash_completion/"gmx-completion"

    # Avoid superenv shim reference
    cc = DevelopmentTools.locate(ENV.cc)
    cxx = DevelopmentTools.locate(ENV.cxx)

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

    gmx_simd = if Hardware::CPU.arm?
      "ARM_NEON_ASIMD"
    else
      "SSE2"
    end

    args = %W[
      -DGMX_VERSION_STRING_OF_FORK=#{tap.user}
      -DGMX_INSTALL_LEGACY_API=ON
      -DGMX_EXTERNAL_ZLIB=ON
      -DGMX_USE_LMFIT=EXTERNAL
      -DGMX_USE_MUPARSER=EXTERNAL
      -DGMX_SIMD=#{gmx_simd}
      -DGMX_USE_RDTSCP=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bash_completion.install bin/"gmx-completion-gmx.bash" => "gmx-completion-gmx.bash"
    bash_completion.install bin/"gmx-completion.bash" => "gmx-completion.bash"
    bash_completion.install "build/scripts/GMXRC.bash" => "gromacs"
    zsh_completion.install "build/scripts/GMXRC.zsh" => "_gromacs"
  end

  def caveats
    <<~EOS
      GMXRC and other scripts installed to:
        #{HOMEBREW_PREFIX}/share/gromacs
    EOS
  end

  test do
    system bin/"gmx", "help"
  end
end
