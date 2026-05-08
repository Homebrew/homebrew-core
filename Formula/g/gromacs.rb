class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "https://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2026.2.tar.gz"
  sha256 "d27e4455e8246177952366798631a0dad9f2e1f567400a6cb854a168dcc050dd"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://ftp.gromacs.org/pub/gromacs/"
    regex(/href=.*?gromacs[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "f7d6b364c85b86c259ae897a580572d159a7f3e733f0427b3b6d0ebb4361c4af"
    sha256                               arm64_sequoia: "1fdcf2f62d117a7e11bfab13d57b49dc843c3c31a3b0d6e4e12c2651be2a926b"
    sha256                               arm64_sonoma:  "0c633a5fb8387d5298677eb57d970556d2730b3d41aa59a2300df2c93336a338"
    sha256                               sonoma:        "ee62f78155a3da81456b5b153aae50c075d3474f6e2376119c2d5d8eebaf581e"
    sha256                               arm64_linux:   "921eb74e182de10ccbf46025f92f3745cfb9780a11c66a00acae96f8b0b211b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4094c3d1a0840f21bfcff79c011e0cfbb8bc84186897f82726c89af65eff20ce"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "lmfit"
  depends_on "muparser"
  depends_on "openblas"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Non-executable GMXRC files should be installed in DATADIR
    inreplace "scripts/CMakeLists.txt", "CMAKE_INSTALL_BINDIR",
                                        "CMAKE_INSTALL_DATADIR"

    # Avoid superenv shim reference
    cc = DevelopmentTools.locate(ENV.cc)
    cxx = DevelopmentTools.locate(ENV.cxx)

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
      -DGMX_VERSION_STRING_OF_FORK=#{tap.user}
      -DGMX_INSTALL_LEGACY_API=ON
      -DGMX_EXTERNAL_ZLIB=ON
      -DGMX_USE_LMFIT=EXTERNAL
      -DGMX_USE_MUPARSER=EXTERNAL
      -DGMX_SIMD=#{gmx_simd}
      -DGMX_USE_RDTSCP=OFF
    ]

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
