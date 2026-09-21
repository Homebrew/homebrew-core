class Lief < Formula
  desc "Library to Instrument Executable Formats"
  homepage "https://lief.re/"
  url "https://github.com/lief-project/LIEF/archive/refs/tags/1.0.0.tar.gz"
  sha256 "2cf412695ff739d82e129db441e5c2025f3bb4873a3d3a1d3dd4cf300b682abd"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "0eaa9b6a3944aeefdf7526e7d61628b7f6088df3b14cdc1673ad662d2849ce8e"
    sha256 cellar: :any, arm64_tahoe:       "d040da382b3b781b0ee299f2f2d1af7fe0b0b66a4a9bb325482d01d39b62a348"
    sha256 cellar: :any, arm64_sequoia:     "33bd4f306ee19669671244135261875dbcbf49d1602c438c923ffb2e5195ab02"
    sha256 cellar: :any, arm64_linux:       "484370a5c63852bfc2c0dd156ddb896dc1f59a1f129edf5ce51fc28ce1e7c069"
    sha256 cellar: :any, x86_64_linux:      "8a3775863038faa6e105edcf4f5a597842eeaf9813815e6441a53b38edb9a42d"
  end

  depends_on "cmake" => :build
  depends_on "frozen" => :build
  depends_on "nlohmann-json" => :build
  depends_on "utf8cpp" => :build
  depends_on "fmt"
  depends_on "spdlog"
  depends_on "tl-expected" => :no_linkage

  resource "mbedtls" do
    url "https://raw.githubusercontent.com/lief-project/LIEF/1.0.0/third-party/mbedtls-4.0.0.r0.gec4044008d.zip"
    sha256 "01aec4471547dec5308853ff0d797611a68a521a10496898b626035dfdc07183"
  end

  resource "tcb-span" do
    url "https://raw.githubusercontent.com/lief-project/LIEF/1.0.0/third-party/tcb-span-b70b0ff.zip"
    sha256 "f3d47ed83507fce94245a9f3cf97bc433cd1116f94d11ac0dca1a6f53bbeb239"
  end

  # Fix build with utf8cpp 4.2
  patch do
    url "https://github.com/lief-project/LIEF/commit/029bba8595a6747805e11fde8ed1443eee2349f6.patch?full_index=1"
    sha256 "11a7827e7c44a0d0dd262af5d5f3f7b4a60083e6cb7afb86f1ee0fcfaa85273e"
    type :unofficial
    resolves "https://github.com/lief-project/LIEF/pull/1380"
  end

  def install
    rm_r Dir["third-party/*"]
    resource("mbedtls").stage do
      (buildpath/"third-party/mbedtls").install Dir["*"]
    end
    resource("tcb-span").stage do
      (buildpath/"third-party/tcb").install "span.hpp"
    end

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DFETCHCONTENT_SOURCE_DIR_LIEF_MBEDTLS=#{buildpath}/third-party/mbedtls
      -DFETCHCONTENT_SOURCE_DIR_LIEF_SPAN=#{buildpath}/third-party/tcb
      -DLIEF_EXAMPLES=OFF
      -DLIEF_EXTERNAL_SPDLOG=ON
      -DLIEF_OPT_EXTERNAL_EXPECTED=ON
      -DLIEF_OPT_FROZEN_EXTERNAL=ON
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
