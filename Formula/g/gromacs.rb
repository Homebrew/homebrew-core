class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "https://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2026.0.tar.gz"
  sha256 "229726f436cc515bfd8c4aa7af3a97b18072f71b5ebd0b08daf6565571e2d9eb"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://ftp.gromacs.org/pub/gromacs/"
    regex(/href=.*?gromacs[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "769850bfcb2c206941c31109107d6651f2627ad86b301ad473a3b33f0e12f5ac"
    sha256                               arm64_sequoia: "c269bcf77c61b27fe58bd21bbdd54f824d0b10dfcd100e49b57e898d3018e486"
    sha256                               arm64_sonoma:  "0c23078e1b96847eff00223efb758e3ed1c86f7bb87c869e45a748b35930c051"
    sha256                               sonoma:        "d688d04c13f506fc22724aec6e59aab1c4cb83b184dc12e28d897ecc9b4e1383"
    sha256                               arm64_linux:   "3724609388020fd8775179ada2bee950bbcd7a5ba2328c86bc05284cd56ec95a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbe6d9f3474b7001ac8e567bec80328dbd19ffe9adafb063208bd4cccfb4dc94"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
  depends_on "lmfit"
  depends_on "openblas"

  uses_from_macos "zlib"

  on_macos do
    conflicts_with "muparser", because: "gromacs ships its own copy of muparser"
  end

  on_linux do
    depends_on "muparser"
  end

  fails_with :clang

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

    gmx_simd = if Hardware::CPU.arm?
      "ARM_NEON_ASIMD"
    elsif OS.mac? && MacOS.version.requires_sse4?
      "SSE4.1"
    else
      "SSE2"
    end

    args = %W[
      -DGROMACS_CXX_COMPILER=#{cxx}
      -DGMX_VERSION_STRING_OF_FORK=#{tap.user}
      -DGMX_INSTALL_LEGACY_API=ON
      -DGMX_EXTERNAL_ZLIB=ON
      -DGMX_USE_LMFIT=EXTERNAL
      -DGMX_SIMD=#{gmx_simd}
    ]
    args << if OS.mac?
      # Use bundled `muparser` as brew formula is linked to libc++ on macOS but we need libstdc++.
      # TODO: Try switching `gromacs` and its dependency tree to use Apple Clang + `libomp`
      "-DFETCHCONTENT_SOURCE_DIR_MUPARSER=#{buildpath}/src/external/muparser"
    else
      "-DGMX_USE_MUPARSER=EXTERNAL"
    end

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
    system bin/"gmx", "help"
  end
end
