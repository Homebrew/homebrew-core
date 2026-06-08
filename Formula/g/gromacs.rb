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
    rebuild 1
    sha256                               arm64_tahoe:   "d4b6551d8a2b82d4cc457f75b741900535f02deee6fb8bbaeed6195d48bd25e5"
    sha256                               arm64_sequoia: "6076b370560e7c6928ee38baebf929c076e2b0b5af7d9bc1b662776040a8c820"
    sha256                               arm64_sonoma:  "73321917f0f4cb6aa1c70c88ab131d1087245c3000c39c3db69892c035b056fa"
    sha256                               sonoma:        "fd3400ec25d38e71c0962d51d31f4453b3b65f39a0f9b05bd05bac09dbc28e60"
    sha256                               arm64_linux:   "dff057ce590437a44d026993aa71bb061ede049dcf6f391e40a9f86e2f60eb34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1364fb0da96dc7a23b2075ad71590668336fd404473c2acb3feb89960815487c"
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
