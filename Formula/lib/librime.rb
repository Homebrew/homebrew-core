class Librime < Formula
  desc "Rime Input Method Engine"
  homepage "https://rime.im"
  url "https://github.com/rime/librime.git",
      tag:      "1.17.0",
      revision: "33e78140250125871856cdc5b42ddc6a5fcd3cd4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ade53b498af1fc609c50c57e610c55b814d62ef915e3cf2b1e12b73d5fefdb95"
    sha256 cellar: :any, arm64_sequoia: "878bc2330e4751244c161346740addd9a1e8bb3fc93ffc59aa488581a8087d7f"
    sha256 cellar: :any, arm64_sonoma:  "bc3c0da35c6eb21fc1200709eac478588d22b8696c3adc060260417d2f8ef8bc"
    sha256 cellar: :any, sonoma:        "28c25a329d898f6a9bd35f66e14e2bcf524c80e02e6d8b7a122e5bfdb67156e5"
    sha256 cellar: :any, arm64_linux:   "938e31799c53dd261d3bad655623347b08f39ad835c22c047cfb1b201215f2c8"
    sha256 cellar: :any, x86_64_linux:  "532c5eb19b66b6e998b81a33f109f077f04dff21cccef81661421cc3c626c0b8"
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
    url "https://github.com/hchunhui/librime-lua/archive/ec52e48ea18f11af37717a01c337f853215cf70b.tar.gz"
    sha256 "73247eb0b506934f8518459d303fe4a31f681a9c1623867b20889a985c4b6e8e"
  end

  resource "octagram" do
    url "https://github.com/lotem/librime-octagram/archive/dfcc15115788c828d9dd7b4bff68067d3ce2ffb8.tar.gz"
    sha256 "7da3df7a5dae82557f7a4842b94dfe81dd21ef7e036b132df0f462f2dae18393"
  end

  resource "predict" do
    url "https://github.com/rime/librime-predict/archive/920bd41ebf6f9bf6855d14fbe80212e54e749791.tar.gz"
    sha256 "38b2f32254e1a35ac04dba376bc8999915c8fbdb35be489bffdf09079983400c"
  end

  resource "proto" do
    url "https://github.com/lotem/librime-proto/archive/657a923cd4c333e681dc943e6894e6f6d42d25b4.tar.gz"
    sha256 "69af91b1941781be6eeceb2dbdc6c0860e279c4cf8ab76509802abbc5c0eb7b3"
  end

  def install
    resources.each do |r|
      r.stage buildpath/"plugins"/r.name
    end

    args = %W[
      -DBUILD_MERGED_PLUGINS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: lib/"rime-plugins")}
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
