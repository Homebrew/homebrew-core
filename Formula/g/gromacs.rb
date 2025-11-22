class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "https://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2025.4.tar.gz"
  sha256 "ca17720b4a260eb73649211e9f6a940ee7543452129844213c3accb0a927a5c3"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://ftp.gromacs.org/pub/gromacs/"
    regex(/href=.*?gromacs[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e0283cd368b2a1ca362ba50b768da381e0e532d058659785d63240d54a66427c"
    sha256 arm64_sequoia: "bbbf675a4dd591bb79a42511f7c1b3e115edc1e32bd8a57d9d9483d60ecc4ff8"
    sha256 arm64_sonoma:  "53555ba802a8f62ed698e4ae9bb5eebe1ec7eace06283c6ebc802f2ce4dac8ea"
    sha256 sonoma:        "d96e944bd26a9c8b8b63424f4a77a88fb21365fb38cfbaa9c691eded796344a0"
    sha256 arm64_linux:   "e0c28149333e84aa32f5cfd4320fd6615b9621e5b646f65e7a30fd238cc4bc04"
    sha256 x86_64_linux:  "f257b91887a5f5bf1049a174ce561fc0f9d97078b0a9f3cad89ac91388fc1403"
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
