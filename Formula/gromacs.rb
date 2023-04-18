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
    rebuild 1
    sha256 arm64_ventura:  "5610ea14f509d07dd8a40c85effd62fe77ea56c2453beb5949a3c9c426986887"
    sha256 arm64_monterey: "bda232518e1cbff5479f5368c1d836b8ca8fff3eafda291cb48e3e0e206d9d37"
    sha256 arm64_big_sur:  "33d2718d8a2fa1bd9bc92eed6685191684fb594be5ce1322b2009725f4d39b52"
    sha256 ventura:        "34e8b2cf4964d9c6e6b0bd778a64b8011429aadfa0e9a4485bc6cc4d40f261b5"
    sha256 monterey:       "fcc9c73467fc316aa8d7e038d36f93a812b7066321aae37c852c2e9bdfbb218f"
    sha256 big_sur:        "67f74c6c8fde47489f5b068296e82b0d1f988f82620a061dece12178493e91ec"
    sha256 x86_64_linux:   "f2b6756ebd07aa2d147d4d764c88c8b5ae82b7610077d11c9ae0bb256f78c8c5"
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
