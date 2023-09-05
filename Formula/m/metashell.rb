class Metashell < Formula
  desc "Metaprogramming shell for C++ templates"
  homepage "http://metashell.org"
  url "https://github.com/metashell/metashell/archive/v5.0.0.tar.gz"
  sha256 "028e37be072ec4e85d18ead234a208d07225cf335c0bb1c98d4d4c3e30c71f0e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2cc250a4e2c795206aed7e6e3c29bd58fd7c48adbb406ac9ad6076249c783537"
    sha256 cellar: :any,                 arm64_monterey: "7cbd8c82695aad556936488bcfcf3bacf33866d2d75401ff31eaf5cd60920997"
    sha256 cellar: :any,                 arm64_big_sur:  "287f647cf8550653078479c27d4e985a456e68ef24491a3de01175e92234e55a"
    sha256 cellar: :any,                 ventura:        "f196e01be3cba5fde64a8114afbd1c4adf6c6ef5a44fc5e7f848cf7f7797d086"
    sha256 cellar: :any,                 monterey:       "5573b01681807008a818cdab233292aaeb7db1bf93694cade04410dd60dc39d1"
    sha256 cellar: :any,                 big_sur:        "e2f9bdc3e9b406683dc706aa08d10efa38e5cebe033268f324341872c62ec390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "069823ccd40ab1274639474bf62285dd7c92cac8afa0006a51cada9a28bd1a12"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "readline"
  end

  def install
    # Build internal Clang
    system "cmake", "-S", "3rd/templight/llvm",
                    "-B", "3rd/templight/build",
                    "-DLLVM_ENABLE_TERMINFO=OFF",
                    "-DLLVM_ENABLE_PROJECTS=clang",
                    *std_cmake_args
    system "cmake", "--build", "3rd/templight/build"
    system "cmake", "--install", "3rd/templight/build"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.hpp").write <<~EOS
      template <class T> struct add_const { using type = const T; };
      add_const<int>::type
    EOS
    output = pipe_output("#{bin}/metashell -H", (testpath/"test.hpp").read)
    assert_match "const int", output
  end
end
