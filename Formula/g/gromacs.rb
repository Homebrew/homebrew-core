class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "https://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2025.3.tar.gz"
  sha256 "8bdfca0268f3f10a7ca3c06e59b62f73ea02420c67211c0ff3912f32d7833c65"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "https://ftp.gromacs.org/pub/gromacs/"
    regex(/href=.*?gromacs[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "cc16a154666e88d12f6315df5f72ab2d7b6d63819cc95cbb7cf9f232ffb26b39"
    sha256 arm64_sequoia: "25af977b9513370eaccc0a682ef95d31d0db9064be6e3932cc40a1f62d18175f"
    sha256 arm64_sonoma:  "08018bd66e4587a21487da6b4061f966ba543d207b417eb939f52b088917d6d4"
    sha256 sonoma:        "5abc7a46dfd4c334e5408eb8c1072876f9991592cf55f91367b7b85a83ac1fb7"
    sha256 arm64_linux:   "614f55427d4e588fdce8841d01681f153557a8aa60df91c086a915e8907e61c5"
    sha256 x86_64_linux:  "96e54ddca2664710ffeb2b862f761834f2d6d143d8da2734f5ecc902114b2a34"
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
