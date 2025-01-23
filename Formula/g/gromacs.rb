class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "https://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2024.4.tar.gz"
  sha256 "ac618ece2e58afa86b536c5a2c4fcb937f0760318f12d18f10346b6bdebd86a8"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://ftp.gromacs.org/pub/gromacs/"
    regex(/href=.*?gromacs[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "3f323aa2f4427e400c8b44767f4f055fb741f491e52f88bb9e33494e31933ca0"
    sha256 arm64_sonoma:  "5b9553a36a9ded42b96264a786bb92cac4b72e3c7a3365ffcabdc9b060eb4dea"
    sha256 arm64_ventura: "18e4ea9c5115110f48e1d9d3c4335f280fecac6c0a429baee79373a9b2fec8b8"
    sha256 sonoma:        "f9940e5bed223d92f809b1c060121e2a5e07600caba24f53166eabdf4b2cf064"
    sha256 ventura:       "78892b9cb50544b7844d4c6fce43467fed77966b9c04a9b1780e4a991c36f813"
    sha256 x86_64_linux:  "8161a164ba75c08c6f30cba0a5d8e7953b2932abd027580c6da21e61cbbdb307"
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
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
