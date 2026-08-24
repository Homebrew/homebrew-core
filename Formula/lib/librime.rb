class Librime < Formula
  desc "Rime Input Method Engine"
  homepage "https://rime.im"
  url "https://github.com/rime/librime.git",
      tag:      "1.17.0",
      revision: "33e78140250125871856cdc5b42ddc6a5fcd3cd4"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d4324c941332adfbddafc4e74f9f7646a56e2af93b1cda3092166de2cd334ad4"
    sha256 cellar: :any, arm64_sequoia: "0552191feac3d9b981bd9b46fda577d2ce67bcf13a11113127a287a55b29c34f"
    sha256 cellar: :any, arm64_sonoma:  "93ead5f657d87599c29b33f6057ca5e4a2b8de7fbf4358040c8fe120d7a4b953"
    sha256 cellar: :any, sonoma:        "0d10f6dcf9f2f7a501981d4d1ee2f92a19496995bb8f86a9789a86e15888d0dc"
    sha256 cellar: :any, arm64_linux:   "6ada8b1343be7c24aa578f49e98e2573b06cd802cfd16dd866a51ed17b131368"
    sha256 cellar: :any, x86_64_linux:  "b9de1ea3a99016ca959931344b9357a5c62b0a9d163bf033474cc88cf06e553e"
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
