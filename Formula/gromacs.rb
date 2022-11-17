class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "https://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2022.4.tar.gz"
  sha256 "c511be602ff29402065b50906841def98752639b92a95f1b0a1060d9b5e27297"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://ftp.gromacs.org/pub/gromacs/"
    regex(/href=.*?gromacs[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "be8a14c02c8fc9b811d237d69ce841709b29bc9f69c1b5dc69db52df3cfb1340"
    sha256 arm64_monterey: "8c26dd00c0d8ff4cbb5308b814d1517aaf99b399c6c0e36bb712ed933bb4860e"
    sha256 arm64_big_sur:  "5a051a93e5a90a97bf9c4b8067bc92f16e744c120cd43427adae024f4515cdf7"
    sha256 monterey:       "551eaf450d80c51c07eab4beb5a868ace8ce885e7649a6b10cf18661fefb4d38"
    sha256 big_sur:        "1eee5851790badf51c072019dd57d0984a545c98a688d50c386640bf68bcc3a3"
    sha256 catalina:       "9957bfae39d1fc1a6312e6d3548c646ba0c61a70bfc67dde3a4c9f88cc8676f7"
    sha256 x86_64_linux:   "a36708d61037ce1f4204a400c3f64e29a6233ef74ec49c3df0f3845c7b9a3565"
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
