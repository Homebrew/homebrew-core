class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "https://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2021.2.tar.gz"
  sha256 "d940d865ea91e78318043e71f229ce80d32b0dc578d64ee5aa2b1a4be801aadb"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://ftp.gromacs.org/pub/gromacs/"
    regex(/href=.*?gromacs[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "d6544181b87b3fc112bac1062701baef98494401db96b9bb66ecdf74592626e5"
    sha256 big_sur:       "ebea4352a0e8e468b72b403fb02c0293ffa86a5b0904b336d9a194a55f908c3a"
    sha256 catalina:      "342033a6ab15cb11014ca9289ea51ecbe8ac6c0d1e1cb6f1fb80bf20d3be8071"
    sha256 mojave:        "5fa4f3d48ec60a17153b6f767869970fd9cf7d92b4348b4fce2d203587b4a5b5"
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
  depends_on "openblas"

  fails_with :clang
  fails_with gcc: "5"
  fails_with gcc: "6"

  # https://gitlab.com/gromacs/gromacs/-/merge_requests/1494
  # Fix build with CMake 3.20+. Remove at next release
  patch do
    url "https://gitlab.com/gromacs/gromacs/-/commit/e4e1263776844d660c471e3d1203acf54cdc855f.diff"
    sha256 "984cfd741bdabf83b54f19e8399b5b75ee20994804bd18299c36a918fbdae8b0"
  end

  # Fix build with CMake 3.20+. Remove at next release
  patch do
    url "https://gitlab.com/gromacs/gromacs/-/commit/5771842a06f483ad52781f4f2cdf5311ddb5cfa1.diff"
    sha256 "2c30d00404b76421c13866cc42afa5e63276f7926c862838751b158df8727b1b"
  end

  def install
    # Non-executable GMXRC files should be installed in DATADIR
    inreplace "scripts/CMakeLists.txt", "CMAKE_INSTALL_BINDIR",
                                        "CMAKE_INSTALL_DATADIR"

    # Avoid superenv shim reference
    gcc = Formula["gcc"]
    cc = gcc.opt_bin/"gcc-#{gcc.any_installed_version.major}"
    cxx = gcc.opt_bin/"g++-#{gcc.any_installed_version.major}"
    inreplace "src/gromacs/gromacs-toolchain.cmake.cmakein" do |s|
      s.gsub! "@CMAKE_LINKER@", "/usr/bin/ld"
      s.gsub! "@CMAKE_C_COMPILER@", cc
      s.gsub! "@CMAKE_CXX_COMPILER@", cxx
    end

    inreplace "src/buildinfo.h.cmakein" do |s|
      s.gsub! "@BUILD_C_COMPILER@", cc
      s.gsub! "@BUILD_CXX_COMPILER@", cxx
    end

    inreplace "src/gromacs/gromacs-config.cmake.cmakein", "@GROMACS_CXX_COMPILER@", cxx

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DGROMACS_CXX_COMPILER=#{cxx}"
      system "make", "install"
    end

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
