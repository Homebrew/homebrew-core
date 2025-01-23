class Librime < Formula
  desc "Rime Input Method Engine"
  homepage "https://rime.im"
  url "https://github.com/rime/librime.git",
      tag:      "1.13.0",
      revision: "e8184dceaf9a89a21d6dc25c1850779cd652c472"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d04890f004a5c3e5cd6d1923a22aab22e46b2088eab740c864f102261d1d7c53"
    sha256 cellar: :any,                 arm64_sonoma:  "262d62125b0c661a74fa0f7b7dde3c5c30d90c5829d620156e5a856bcb99e402"
    sha256 cellar: :any,                 arm64_ventura: "a9d956451acdad4a081f82710cd09091c0f7a87d8009c6caad6542b93d6ae4c2"
    sha256 cellar: :any,                 sonoma:        "4c9bdad98763334157b974af05aec1470a14342df3ff7dfb9fd38810d894a85b"
    sha256 cellar: :any,                 ventura:       "97db5688ee2d550d16b3f4c6658cb9e2e6147e2bee1d4e218e7fdcb235b44c22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48995b5c63a7219289de9fe15f5b3d26824f4f242093853b3fed410eb422986b"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "icu4c@76" => :build
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
        revision: "e3912a4b3ac2c202d89face3fef3d41eb1d7fcd6"
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
