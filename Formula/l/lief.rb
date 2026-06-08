class Lief < Formula
  desc "Library to Instrument Executable Formats"
  homepage "https://lief.re/"
  url "https://github.com/lief-project/LIEF/archive/refs/tags/0.17.6.tar.gz"
  sha256 "5fbbd19c85912d417eabbaef2b98e70144496356964685b82e0792d708b9be87"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b6f221f471b26cf8f34d1ae95cae33fa8ef6d28ef4d6859acab22d452b3b1a1b"
    sha256 cellar: :any,                 arm64_sequoia: "5c50472f27105fba066b9acf694e57de0905dee0a8be898baa501136d47e08c3"
    sha256 cellar: :any,                 arm64_sonoma:  "aa688088af9449e251af641056cd24de225fefbbf1cd99c439a86c1265d76a6c"
    sha256 cellar: :any,                 sonoma:        "b5981714089ac3c5c9351daf530a56b5824fb204d002968b3f2e9cba5b62cfa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1293a3e476728b496a7cbb3c2053f11251e0f69b9b10a4b1974dc888642acf3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7b066a970ed4ed3ec174e6a5dafb462b3bab06b6dfdce5ce19445a9b350e25e"
  end

  depends_on "cmake" => :build
  depends_on "frozen" => :build
  depends_on "nlohmann-json" => :build
  depends_on "utf8cpp" => :build
  depends_on "fmt"
  depends_on "mbedtls@3" # https://github.com/lief-project/LIEF/commit/71e69423090e1bfaee7d2512a843605a373b1026
  depends_on "spdlog"
  depends_on "tl-expected" => :no_linkage

  def install
    rm_r(Dir["third-party/*"] - Dir["third-party/tcb-span*"])

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DLIEF_EXAMPLES=OFF
      -DLIEF_EXTERNAL_SPDLOG=ON
      -DLIEF_OPT_EXTERNAL_EXPECTED=ON
      -DLIEF_OPT_FROZEN_EXTERNAL=ON
      -DLIEF_OPT_MBEDTLS_EXTERNAL=ON
      -DLIEF_OPT_NLOHMANN_JSON_EXTERNAL=ON
      -DLIEF_OPT_UTFCPP_EXTERNAL=ON
      -DLIEF_SO_VERSION=ON
      -DLIEF_USE_CCACHE=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <LIEF/LIEF.hpp>

      int main(void) {
        std::unique_ptr<LIEF::ELF::Binary> elf = LIEF::ELF::Parser::parse("hello");
        LIEF::ELF::DynamicEntryRunPath runpath("/usr/local/lib");
        elf->add(runpath);
        elf->write("hello-rpath");
        return 0;
      }
    CPP

    cp test_fixtures("elf/hello"), testpath
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-L#{lib}", "-lLIEF"
    system "./test"
    assert_match %r{RUNPATH\s+/usr/local/lib$}, shell_output("objdump -p hello-rpath")
  end
end
