class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://github.com/openbabel/openbabel"
  url "https://github.com/openbabel/openbabel/archive/refs/tags/openbabel-3-2-1.tar.gz"
  version "3.2.1"
  sha256 "e140c25480fe1678d00b9a52462368fa4e7805fba67b12ee496784437f3e239e"
  license "GPL-2.0-only"
  head "https://github.com/openbabel/openbabel.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "603093a5e4deab773c1f1fbcbe3fc1778a45e0e26a1a950d8435b362982e39f4"
    sha256 arm64_tahoe:       "7980fe2ac4bc44fb8836c6fbe47781c5cc449184287a711953417cec0169d5e5"
    sha256 arm64_sequoia:     "c463a919a8c1c96967ae4f97b0fbf6ec9c093510955830c2c7dfe836ab451843"
    sha256 arm64_linux:       "2b2c65c0f6da95edfad0cb5686f8c590ceeb63a9484eeaf8dae0dd23744d2298"
    sha256 x86_64_linux:      "8783b8513e67d61d177f615960b036587db1f5c93ac8e4f8f7922d9492f9b65d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rapidjson" => :build
  depends_on "swig" => :build

  depends_on "cairo"
  depends_on "eigen"
  depends_on "inchi"
  depends_on "python@3.15"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "surelog", because: "both install `roundtrip` binaries"

  deny_network_access!

  def install
    args = %W[
      -DINCHI_INCLUDE_DIR=#{formula_opt_include("inchi")}/inchi
      -DOPENBABEL_USE_SYSTEM_INCHI=ON
      -DRUN_SWIG=ON
      -DPYTHON_BINDINGS=ON
      -DPYTHON_EXECUTABLE=#{python3}
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
