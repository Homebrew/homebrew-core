class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "https://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2024.3.tar.gz"
  sha256 "bbda056ee59390be7d58d84c13a9ec0d4e3635617adf2eb747034922cba1f029"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://ftp.gromacs.org/pub/gromacs/"
    regex(/href=.*?gromacs[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "6501170e70a351073c617f89ed1f75f60deb6f29f2acf6f84b59e7bc9801efa0"
    sha256 arm64_sonoma:   "5d3ed8797fa7be5ed3f453007abb9ad771a6ed1ae6a5f0f69117133b1cd958e9"
    sha256 arm64_ventura:  "a97d299639a99915be3df4944b5a6ab55c3c1b05fa88ebfc2e8345ee23e8fd0d"
    sha256 arm64_monterey: "31462aeb578caf83faf95225bda79c241eac37c687c881a4b1be24ee41bf4a87"
    sha256 sonoma:         "c1b1b9fb2bf40d609f3642b356dc24699bbcbb6345b16bf52812d77b32f554cc"
    sha256 ventura:        "3699cdc6a4a31afd83cd71e7e84f40f313b20b1600fbc6b6cb236ca260af0d38"
    sha256 monterey:       "4b2d622905ab50fbf8163d9e284d4fdc4998f612d426a09261ee4b05ed2e1b04"
    sha256 x86_64_linux:   "a2d8685bc64e9315f821fe1492f39316b0609f15d658204897ea31af3b723bca"
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
