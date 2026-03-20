class Librime < Formula
  desc "Rime Input Method Engine"
  homepage "https://rime.im"
  url "https://github.com/rime/librime.git",
      tag:      "1.16.1",
      revision: "de4700e9f6b75b109910613df907965e3cbe0567"
  license "BSD-3-Clause"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "654b9fd252224219de309cd53a8f39420a440f78c8f563008cc78d97a1ecbeb8"
    sha256 cellar: :any,                 arm64_sequoia: "a3cd8893f80309f9f2da2c61d60540ee5217e2a46c4f8664c20e6925ae1ea07c"
    sha256 cellar: :any,                 arm64_sonoma:  "3eb23f3bf1870807a2e8b83b769276d67e195aacbba43b4e39fd3a5a7861bc90"
    sha256 cellar: :any,                 sonoma:        "390c9aef53873722bbda5fdc5d2cefcd94698df4ba5669a96aab24cb5aaa7362"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf23b3d017fe7bf9703e3ee5980e57f33c15979e566c15dbbcf0ca59525d7871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b99d2dffe86f4c2ccb055a6c607b9456f2357f2d0c240a5f83f48661b39159a"
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
    url "https://github.com/hchunhui/librime-lua/archive/68f9c364a2d25a04c7d4794981d7c796b05ab627.tar.gz"
    sha256 "3c4a60bacf8dd6389ca1b4b4889207b8f6c0c6a43e7b848cdac570d592a640b5"
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
