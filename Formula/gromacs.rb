class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "https://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2023.tar.gz"
  sha256 "ac92c6da72fbbcca414fd8a8d979e56ecf17c4c1cdabed2da5cfb4e7277b7ba8"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://ftp.gromacs.org/pub/gromacs/"
    regex(/href=.*?gromacs[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "121ee4296691d422344e7295ad0606fa5cfcd3504534a142d6fc89308726fd0a"
    sha256 arm64_monterey: "549c85b8dd66ff7d86147fa072ca6de0c56545a1c6a4b9c5cf47d511bd3c991e"
    sha256 arm64_big_sur:  "fe588294099d3a2301f7a47aeda12966158e43904567cf2080aca2bdf81a4063"
    sha256 ventura:        "c7fa552af63e395219c8cd24517f989dbe97e9df29e80ae68bb4a840d12110dd"
    sha256 monterey:       "fcfd520513c4d0a9f79e19edac79c7752b0b0d52e135316e1dd8a29d50cebdaf"
    sha256 big_sur:        "2f938fdeb2415927628d65b8cbd51c51cd18087930bdee7c67dd0629508e09b3"
    sha256 x86_64_linux:   "78b8768a142696cb544b02356a8071e849193368b78f880e14e7ec3161ae3e31"
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
