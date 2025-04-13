class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://github.com/openbabel/openbabel"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/openbabel/openbabel.git", branch: "master"

  stable do
    url "https://github.com/openbabel/openbabel/releases/download/openbabel-3-1-1/openbabel-3.1.1-source.tar.bz2"
    sha256 "a6ec8381d59ea32a4b241c8b1fbd799acb52be94ab64cdbd72506fb4e2270e68"

    # Backport support for configuring PYTHON_INSTDIR to avoid Setuptools
    patch do
      url "https://github.com/openbabel/openbabel/commit/f7910915c904a18ac1bdc209b2dc9deeb92f7db3.patch?full_index=1"
      sha256 "f100bb9bffb82b318624933ddc0027eeee8546bf4d6deda5067ecbd1ebd138ea"
    end
  end

  bottle do
    rebuild 4
    sha256                               arm64_sequoia: "6e65ad2651937d58c9c4c023948ef066fb47d80c1add72a46478dc068a3b8889"
    sha256                               arm64_sonoma:  "4dae715c5d682d7dbc2629f8942de25888cb0a17ecf7097d0e4b0b5293f6a599"
    sha256                               arm64_ventura: "74af59afb37e1a715f5993d8f2003c2a4b9cfcd8c0d25706658318ca8e0bfe4b"
    sha256                               sonoma:        "e5e91a303d0090db9fe25ea23850d11967f37f4bc97a242c98e3309d35323d58"
    sha256                               ventura:       "0a1482bfbb03ce95e687277d86aa7c1bac4dd1b4f9daeeebb5e7197196877c8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "742382d270de232c3470fb281db5d1c5f47e15e19912fab122dfb33459075b72"
    sha256                               x86_64_linux:  "e9f6607712d55e1397a70b5e5242664ad606f8a0b990deb36161f3f11ddaa1af"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rapidjson" => :build
  depends_on "swig" => :build

  depends_on "cairo"
  depends_on "eigen"
  depends_on "inchi"
  depends_on "python@3.13"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def python3
    "python3.13"
  end

  conflicts_with "surelog", because: "both install `roundtrip` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DINCHI_INCLUDE_DIR=#{Formula["inchi"].opt_include}/inchi",
                    "-DOPENBABEL_USE_SYSTEM_INCHI=ON",
                    "-DRUN_SWIG=ON",
                    "-DPYTHON_BINDINGS=ON",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DPYTHON_INSTDIR=#{prefix/Language::Python.site_packages(python3)}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match <<~EOS, shell_output("#{bin}/obabel -:'C1=CC=CC=C1Br' -omol")

        7  7  0  0  0  0  0  0  0  0999 V2000
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 Br  0  0  0  0  0  0  0  0  0  0  0  0
        1  6  1  0  0  0  0
        1  2  2  0  0  0  0
        2  3  1  0  0  0  0
        3  4  2  0  0  0  0
        4  5  1  0  0  0  0
        5  6  2  0  0  0  0
        6  7  1  0  0  0  0
      M  END
    EOS

    system python3, "-c", "from openbabel import openbabel"
  end
end
