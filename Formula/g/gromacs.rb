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
    sha256 arm64_sequoia: "44f56f6256f9fa1fef887b7049692de7a76aab4fcdc184da7874e5cb38e1cddc"
    sha256 arm64_sonoma:  "b2a693c17dca973a459496021fa1bd83d25c361af9438cba5ba1d395cc6d5daf"
    sha256 arm64_ventura: "cc397203c9c8b1951205e6a28670f072b4103fc29b30586bd636dacf7d22d2d1"
    sha256 sonoma:        "8eec8e174badc80050dc8039f075fc048ced62a312b525dc9b2149893aa18a53"
    sha256 ventura:       "6823221c0eee4ecbf4c0f4df722a42f993a7d3c1e6d6f8ab6a52efbbb84128fc"
    sha256 x86_64_linux:  "14733c2fbae27301cefcb3ac77cccd2699a46223f2fdb9fe6782661baa10c19d"
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
  depends_on "muparser"
  depends_on "openblas"

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
      -DGMX_USE_MUPARSER=EXTERNAL
    ]

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
