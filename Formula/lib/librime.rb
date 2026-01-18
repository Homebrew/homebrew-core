class Librime < Formula
  desc "Rime Input Method Engine"
  homepage "https://rime.im"
  url "https://github.com/rime/librime.git",
      tag:      "1.16.0",
      revision: "a251145d3aafa33871824a40bbec04c966bd8b56"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "332447e47986003e838ce0f8a7b1ee492294d1e63b476b0fdf58d1d45d946d62"
    sha256 cellar: :any,                 arm64_sequoia: "f9ad344a6d347d8ca6fe201b644b31370177a924f0f04d0e0175772983094605"
    sha256 cellar: :any,                 arm64_sonoma:  "5d0ddc59faf1383c513a4ec8a6e282ca741342874c3063265f407c4ef275e7d5"
    sha256 cellar: :any,                 sonoma:        "b6a7d0d562e9009b73ee535195231506b1c9550edeff57f19da2f79b44ab8ec9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47a15181c449c458bed0637ad2c0f6b252ed44895e461c5741b33cf384908bf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5364dfc32fe4907f06f139838e68ffe52dccade8e4013918935cfcc209df6eeb"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "icu4c@78" => :build
  depends_on "pkgconf" => :build

  depends_on "capnp"
  depends_on "gflags"
  depends_on "glog"
  depends_on "leveldb"
  depends_on "lua"
  depends_on "marisa"
  depends_on "opencc"
  depends_on "yaml-cpp"

  resource "lua" do
    url "https://github.com/hchunhui/librime-lua.git",
        revision: "68f9c364a2d25a04c7d4794981d7c796b05ab627"
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
      -DBUILD_TEST=OFF
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
