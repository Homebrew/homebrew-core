class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "https://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2022.tar.gz"
  sha256 "fad60d606c02e6164018692c6c9f2c159a9130c2bf32e8c5f4f1b6ba2dda2b68"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "https://ftp.gromacs.org/pub/gromacs/"
    regex(/href=.*?gromacs[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "3d35e4ea1e4c7fa4fdcde54ab2e8d282696ed75af001700ec5a9bae2bbe3e4b4"
    sha256 arm64_big_sur:  "ba2a9c53c317c3638bb7bd016dbea1628c2ec59dca48a551e7bec097a0b6394d"
    sha256 monterey:       "bcb3b9d29162c3770a3c3483f3fe21ee4b2b28f45f87ba9454ecccafcb785573"
    sha256 big_sur:        "2bfd158e1a9b084e8702d6896fa7e1c727649f56bb0d49a4c4e7f4b9c3a7a827"
    sha256 catalina:       "0a2c0708b2f776e2f1426c3eed1eb28b1da752c1c5e7f9cba812b8416f99a6c1"
    sha256 x86_64_linux:   "61eb1c4f9ddac25ccf24715ecfab900025c15c775f819b86b1a48f40b6f6d3b9"
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
