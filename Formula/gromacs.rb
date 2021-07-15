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
    sha256 arm64_big_sur: "4999db93029325282056050232bc89c6f0261df9bff405d676631c326da75a6d"
    sha256 big_sur:       "48af6ab3affcfc57a701744ea904c8f942f2ab34554ba6aeeee6ab87c1197a90"
    sha256 catalina:      "517993a760552b80638aa56b057a5128cf6536d6ee25a469ea4dd7613c701d62"
    sha256 mojave:        "a4ad5635279fe7f15a7c9809f4d9ddd1bb2cf9e8836329f1baa8021bbe0e8065"
    sha256 x86_64_linux:  "14c8566284734106bfe5b219aaad16188673abd06695dce99328a4a2aa778a38"
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
