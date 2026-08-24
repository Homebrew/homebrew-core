class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "https://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2026.3.tar.gz"
  sha256 "1094b7bbc6a3960223827114626657110b40096cdf9598a727935fc84ebf8aa0"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "https://ftp.gromacs.org/pub/gromacs/"
    regex(/href=.*?gromacs[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256               arm64_tahoe:   "02a9776d85ea5edd18e2674449a956f98549b395447b10dcdc4f60282e0e7695"
    sha256               arm64_sequoia: "be4cfd1dc5417cf2bcb041b51d0a3db78aa55763573f8b17e0db63736df356fc"
    sha256               arm64_sonoma:  "d6bca88f3136dd0d34eec16238f59ddd02cab8213b13c34dff4c22d9e9a8a5a5"
    sha256               sonoma:        "fd6455f4fc53cb7ae20ec791ac11c3c48ceda71ce773ddcf386cd77eed8c4a8e"
    sha256               arm64_linux:   "da7f478ef0fbca1925325378c85cbd7b31825364e452f60da5be66e5641f51ad"
    sha256 cellar: :any, x86_64_linux:  "6850199adbd3321318d8effc07477fe1ddcb2edd41bb1664c97b5f26f434197f"
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
    # Completion workaround
    inreplace "scripts/GMXRC.bash.cmakein", "$GMXBIN/gmx-completion", bash_completion/"gmx-completion"

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

    bash_completion.install bin/"gmx-completion-gmx.bash" => "gmx-completion-gmx.bash"
    bash_completion.install bin/"gmx-completion.bash" => "gmx-completion.bash"
    bash_completion.install "build/scripts/GMXRC.bash" => "gromacs"
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
