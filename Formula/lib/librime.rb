class Librime < Formula
  desc "Rime Input Method Engine"
  homepage "https://rime.im"
  url "https://github.com/rime/librime.git",
      tag:      "1.12.0",
      revision: "c7ab6390c143a11d670f3add41218111edb883c9"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4323fda208914bea9fe7fba22b29cdd85a05fe13c10c143c65587a09eb16bb29"
    sha256 cellar: :any,                 arm64_sonoma:  "55204838b59cafe490ca424d01f514e12f6493a66951bde7861ed6e7e918aff0"
    sha256 cellar: :any,                 arm64_ventura: "8fefeb9c26128c48f185c36db20467b96e8a853d08fcab0528a3a7ad3f89abee"
    sha256 cellar: :any,                 sonoma:        "f5376fcc0570920ac5e5f5b079d8149614469498a069509199e3c25a0704658f"
    sha256 cellar: :any,                 ventura:       "902a7514f6a6be7439a75813e1dddfa01964fa8ecf25b618c54cdbb1ebef4e4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de4f702cbdfc346a5b1b4841da416a945842d343f2b7736da0f44b85cb07d008"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "icu4c@76" => :build
  depends_on "pkgconf" => :build

  depends_on "capnp"
  depends_on "gflags"
  depends_on "glog"
  depends_on "googletest"
  depends_on "leveldb"
  depends_on "lua"
  depends_on "marisa"
  depends_on "opencc"
  depends_on "yaml-cpp"

  on_linux do
    depends_on "libunwind"
  end

  resource "lua" do
    url "https://github.com/hchunhui/librime-lua.git",
        revision: "b210d0cfbd2a3cc6edd4709dd0a92c479bfca10b"
  end

  resource "octagram" do
    url "https://github.com/lotem/librime-octagram.git",
        revision: "dfcc15115788c828d9dd7b4bff68067d3ce2ffb8"
  end

  resource "predict" do
    url "https://github.com/rime/librime-predict.git",
        revision: "920bd41ebf6f9bf6855d14fbe80212e54e749791"
  end

  resource "proto" do
    url "https://github.com/lotem/librime-proto.git",
        revision: "657a923cd4c333e681dc943e6894e6f6d42d25b4"
  end

  def install
    resources.each do |r|
      r.stage buildpath/"plugins"/r.name
    end

    args = %W[
      -DBUILD_MERGED_PLUGINS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DENABLE_EXTERNAL_PLUGINS=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "rime_api.h"

      int main(void)
      {
        RIME_STRUCT(RimeTraits, rime_traits);
        return 0;
      }
    CPP

    system ENV.cc, "./test.cpp", "-o", "test"
    system testpath/"test"
  end
end
