class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "https://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.tar.gz"
  sha256 "f96afbdb000d7375426644fb2f25baff9a63136dddce6551ea0fd20059bfce3b"
  license "AGPL-3.0-only"
  revision 13

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d1375d1d4cc6303dc9b156988355553dc8d6ec59348e337a52f55843ec300482"
    sha256 cellar: :any,                 arm64_monterey: "b4e0db7bbfb6ba92f46db0d2158b214b2c5be227d1b397996ffaf2575e42f723"
    sha256 cellar: :any,                 arm64_big_sur:  "d06b85bef4251aa6563e5ab30dbf11ae5e9474811cac288006f9ea30c18e419e"
    sha256 cellar: :any,                 ventura:        "b8f1a95c50bd350a81f094fde02de5efc6d2689b8308c0d9db975c8ceb321228"
    sha256 cellar: :any,                 monterey:       "3c9f5f25a3593caa160ee0c2e2843ddd400a2c6769df5c94654a7ae98c0ce6db"
    sha256 cellar: :any,                 big_sur:        "35f850be27e9b49d8f404c630632e782229db76072b08a3fd41e5fb85089a0d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f106e8ed2dfc18b30bc46e9bf416f5b3cc15c4e16045bf47aaeaabf36c7a7fd1"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"

  conflicts_with "dynet", because: "freeling ships its own copy of dynet"
  conflicts_with "eigen", because: "freeling ships its own copy of eigen"
  conflicts_with "foma", because: "freeling ships its own copy of foma"
  conflicts_with "hunspell", because: "both install 'analyze' binary"

  # Fixes `error: use of undeclared identifier 'log'`
  # https://github.com/TALP-UPC/FreeLing/issues/114
  patch do
    url "https://github.com/TALP-UPC/FreeLing/commit/e052981e93e0a663784b04391471a5aa9c37718f.patch?full_index=1"
    sha256 "02c8b9636413182df420cb2f855a96de8760202a28abeff2ea7bdbe5f95deabc"
  end

  # Fixes `error: use of undeclared identifier 'fabs'`
  # Also reported in issue linked above
  patch do
    url "https://github.com/TALP-UPC/FreeLing/commit/36e267b453c4f2bce88014382c7e661657d1b234.patch?full_index=1"
    sha256 "6cf1d4dfa381d7d43978cde194599ffadf7596bab10ff48cdb214c39363b55a0"
  end

  # Also fixes `error: use of undeclared identifier 'fabs'`
  # See issue in first patch
  patch do
    url "https://github.com/TALP-UPC/FreeLing/commit/34a1a78545fb6a4ca31ee70e59fd46211fd3f651.patch?full_index=1"
    sha256 "8f7f87a630a9d13ea6daebf210b557a095b5cb8747605eb90925a3aecab97e18"
  end

  # Fixes `error: 'pow' was not declared in this scope` and
  # `error: 'sqrt' was not declared in this scope`.
  # Remove this and other patches with next release.
  patch do
    url "https://github.com/TALP-UPC/FreeLing/commit/48eb3470416cbfd0026eae9f9ca832bb68269273.patch?full_index=1"
    sha256 "8430804b9a8695d3212946c00562b1cf2d3a0bbb5cb94ac48222f1a952401caf"
  end

  def install
    # Allow compilation without extra data (more than 1 GB), should be fixed
    # in next release
    # https://github.com/TALP-UPC/FreeLing/issues/112
    inreplace "CMakeLists.txt", "SET(languages \"as;ca;cs;cy;de;en;es;fr;gl;hr;it;nb;pt;ru;sl\")",
                                "SET(languages \"en;es;pt\")"
    inreplace "CMakeLists.txt", "SET(variants \"es/es-old;es/es-ar;es/es-cl;ca/balear;ca/valencia\")",
                                "SET(variants \"es/es-old;es/es-ar;es/es-cl\")"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end

    libexec.install "#{bin}/fl_initialize"
    inreplace "#{bin}/analyze",
      ". $(cd $(dirname $0) && echo $PWD)/fl_initialize",
      ". #{libexec}/fl_initialize"
  end

  test do
    expected = <<~EOS
      Hello hello NN 1
      world world NN 1
    EOS
    assert_equal expected, pipe_output("#{bin}/analyze -f #{pkgshare}/config/en.cfg", "Hello world").chomp
  end
end
