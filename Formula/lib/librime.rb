class Librime < Formula
  desc "Rime Input Method Engine"
  homepage "https://rime.im"
  url "https://github.com/rime/librime.git",
      tag:      "1.12.0",
      revision: "c7ab6390c143a11d670f3add41218111edb883c9"
  license "BSD-3-Clause"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "icu4c@76" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build

  depends_on "lua"

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

  def install
    resources.each do |r|
      r.stage buildpath/"plugins"/r.name
    end

    ENV.append_to_cflags "-fPIC" if OS.linux?

    # TODO: Dependents should moved to `depends_on` block, but it is not work now
    system "make", "deps"

    args = %W[
      -DBUILD_MERGED_PLUGINS=OFF
      -DBUILD_TEST=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DENABLE_EXTERNAL_PLUGINS=ON
      -DENABLE_LOGGING=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "rime_api.h"

      int main(int argc, char* argv[])
      {
        RIME_STRUCT(RimeTraits, rime_traits);
        return 0;
      }
    CPP

    system ENV.cc, "./test.cpp", "-o", "test"
    system testpath/"test"
  end
end
