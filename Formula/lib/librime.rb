class Librime < Formula
  desc "Rime Input Method Engine"
  homepage "https://rime.im"
  url "https://github.com/rime/librime.git",
      tag:      "1.17.0",
      revision: "33e78140250125871856cdc5b42ddc6a5fcd3cd4"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3bca671c0df02b7255a016b10730cf2b21dcceaf4e592b5f97ae96cbce12baf0"
    sha256 cellar: :any, arm64_sequoia: "f474aaf2a389ec41a0d65492899e8610538c21222a6df8aaa6dd6759c8f3ef6c"
    sha256 cellar: :any, arm64_sonoma:  "9af0c34d02ba65b9168f83c1b2db66a2336249889d484f145a7cd12a1124f10e"
    sha256 cellar: :any, sonoma:        "36dfabde5098c7317b49e216c92127f742c2ca6d4894b584cba3689e1c3e575b"
    sha256 cellar: :any, arm64_linux:   "56db20f3ce1dfd026237eb4c372ab9a4752c5be6e2473d112eb385560c036ded"
    sha256 cellar: :any, x86_64_linux:  "95a4732b31cb9008e7c31a2fef8b7631a331b1eea4f37aabb45ecf40de3b60ad"
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
