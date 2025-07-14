class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "https://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2025.1.tar.gz"
  sha256 "0adf621a80fd8043f8defec84ce02811c0cdf42a052232890932d81f25c4d28a"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://ftp.gromacs.org/pub/gromacs/"
    regex(/href=.*?gromacs[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "bf9e1f90f23301105b419d8b5a9e13f76c7ae11a80803ae31a258ac6eb0eb76a"
    sha256 arm64_sonoma:  "9be83042cdc1753bc52e215d78bd571a3257265f5befb8a0d28316003bfa9046"
    sha256 arm64_ventura: "542b7cc88c9bee42687dbe6a9e07e9ab3c89222402f2101cc3d31464a6d4b560"
    sha256 sonoma:        "67b0c64976ae384d3043565a7137f086c9d7997cce11f0ec79ba18d8787c7b5e"
    sha256 ventura:       "b48883b24262326dba96ad2392bd1bb9a2b221eea6a671bb1e4e067ead3a5a06"
    sha256 arm64_linux:   "c8a2701c95dd18c8e208961a8490dac0faa57d77ee3d605b5bb1be93b3ecea53"
    sha256 x86_64_linux:  "c6614ae480f0635f9ec6f1cfaa8baf37e813aaa737e95ad585ce2e6a08d0c136"
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

    args = %W[
      -DGROMACS_CXX_COMPILER=#{cxx}
      -DGMX_VERSION_STRING_OF_FORK=#{tap.user}
      -DGMX_INSTALL_LEGACY_API=ON
      -DGMX_EXTERNAL_ZLIB=ON
      -DGMX_USE_LMFIT=EXTERNAL
    ]
    args << if OS.mac?
      # Use bundled `muparser` as brew formula is linked to libc++ on macOS but we need libstdc++.
      # TODO: Try switching `gromacs` and its dependency tree to use Apple Clang + `libomp`
      "-DFETCHCONTENT_SOURCE_DIR_MUPARSER=#{buildpath}/src/external/muparser"
    else
      "-DGMX_USE_MUPARSER=EXTERNAL"
    end

    # Force SSE2/SSE4.1 for compatibility when building Intel bottles
    if Hardware::CPU.intel?
      gmx_simd = if OS.mac? && MacOS.version.requires_sse4?
        "SSE4.1"
      else
        "SSE2"
      end
      args << "-DGMX_SIMD=#{gmx_simd}"
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
