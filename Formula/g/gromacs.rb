class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "https://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2025.2.tar.gz"
  sha256 "0df09f9d45a99ef00e66b9baa9493a27e906813763a3b6c7672217c66b43ea11"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "https://ftp.gromacs.org/pub/gromacs/"
    regex(/href=.*?gromacs[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "280c30eef948fc0e30ed6d46c9799e89036f1308fbf0f2b1be73c852b91dea73"
    sha256 arm64_sonoma:  "10e8472fcbe3888c61f80d3ecc51ff4aa1162a8956362191be160b94232dc4a4"
    sha256 arm64_ventura: "b0f17f247bec1b24026a87c8cadf9eb313e1acdd10c49588c2c8c9e3ac945832"
    sha256 sonoma:        "635b9934811e55ca1be5e22abdf94ae5c47fe81b24cc5b8efef8f7d6f012b3f9"
    sha256 ventura:       "184a9226beada9b7e8116fc658030af7baa89ca30cb4fe0a15c470de7a19b174"
    sha256 arm64_linux:   "20c104aa1ee12c0f0181ba37bd38ed97d16859dd0764cfb1929d75a00439cdff"
    sha256 x86_64_linux:  "0cbebc9d0041f0ff51839ba8d202177a11ac79d475679e7fd0624abff06a896d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "lmfit"
  depends_on "muparser"
  depends_on "openblas"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
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
      -DGROMACS_CXX_COMPILER=#{cxx}
      -DGMX_VERSION_STRING_OF_FORK=#{tap.user}
      -DGMX_INSTALL_LEGACY_API=ON
      -DGMX_EXTERNAL_ZLIB=ON
      -DGMX_USE_LMFIT=EXTERNAL
      -DGMX_USE_MUPARSER=EXTERNAL
      -DGMX_SIMD=#{gmx_simd}
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
