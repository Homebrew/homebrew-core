class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://github.com/openbabel/openbabel"
  url "https://github.com/openbabel/openbabel/archive/refs/tags/openbabel-3-2-0.tar.gz"
  sha256 "9aadf9f01b3d0ff15d49fcd28d7d76b923218d70bf10f99ea4cc466607f4c7e2"
  license "GPL-2.0-only"
  head "https://github.com/openbabel/openbabel.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "fe47f3f9a0fcbdc70c449469cd5d8caee18e1861e31d69e8fb4187c585bc078d"
    sha256               arm64_sequoia: "86b1026f7992fe9c7b8f7ddbca7426267764ad3471b92ba1d64ca0dad7bf7d3d"
    sha256               arm64_sonoma:  "ee4285d661a4c74da24bc9b3523672a7ff10cbe65a86ab7302afb10bdcc67ebb"
    sha256               sonoma:        "8a764adf6425fa7b3c505f9af5a91a19f5f5da856a7fee9000c41634bc37f816"
    sha256 cellar: :any, arm64_linux:   "f5060a0e0d493709b247645fe9da90e5f20b041863fdadf1deae220fd50559ce"
    sha256 cellar: :any, x86_64_linux:  "8de4b7ab8579307729ddccb05e959d2eded32475c57a34ee3c37777bcfc458e2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rapidjson" => :build
  depends_on "swig" => :build

  depends_on "cairo"
  depends_on "eigen"
  depends_on "inchi"
  depends_on "python@3.14"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def python3
    "python3.14"
  end

  conflicts_with "surelog", because: "both install `roundtrip` binaries"

  def install
    args = %W[
      -DINCHI_INCLUDE_DIR=#{Formula["inchi"].opt_include}/inchi
      -DOPENBABEL_USE_SYSTEM_INCHI=ON
      -DRUN_SWIG=ON
      -DPYTHON_BINDINGS=ON
      -DPYTHON_EXECUTABLE=#{which(python3)}
      -DPYTHON_INSTDIR=#{prefix/Language::Python.site_packages(python3)}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
