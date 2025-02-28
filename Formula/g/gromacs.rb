class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "https://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2025.0.tar.gz"
  sha256 "a27ad35a646295bbec129abe684d9d03d1e2e0bd76b0d625e9055746aaefae82"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://ftp.gromacs.org/pub/gromacs/"
    regex(/href=.*?gromacs[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "6cc200d4ba4bf329a938cbc7fc764cf1a04129ccbdb0d4c2cead704687c34c07"
    sha256 arm64_sonoma:  "d50209fbcd809d589b074630fc7dbe2500e92805d7f7a015738e04a9fa57ebaa"
    sha256 arm64_ventura: "44883802f84b98b2e87a880c01516bb73cb61451340ee1f0ee810b16e53fe8fb"
    sha256 sonoma:        "7ce3fe9602c84c79c6e5928dbcfada9911f917c4546cc97a015bf741ce828f09"
    sha256 ventura:       "b315971b69f88f0980ccbb35a8b845029a4d8f06579771c2d926d4ab70b4ee53"
    sha256 x86_64_linux:  "1ba13ed29e1768e33f88d9aa557373ae76a9283fc061ee2e1258819fd90a269b"
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
