class Librime < Formula
  desc "Rime Input Method Engine"
  homepage "https://rime.im"
  url "https://github.com/rime/librime.git",
      tag:      "1.15.0",
      revision: "75bc43ae9acdd2042d150a8c446e9ac8b6d77c84"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e9ac3d0096903a7c93752b927f6a827189cb8b922564a2eab8cf3715cd68e239"
    sha256 cellar: :any,                 arm64_sequoia: "9f8dc11482f6a3aed9884d939a70e4ab259ab4aaee6118c3447e50f61de59faf"
    sha256 cellar: :any,                 arm64_sonoma:  "cf5028b839271e12231caef38b943f9ae715136f78b01c5ec7e4ad9764c06676"
    sha256 cellar: :any,                 sonoma:        "1975705ba31371e312941ae3f7360e6cb24d0fe8c9ccbd427cd4bca0718050fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "966948bbcfa84ad0c66afbdf506eab7dc46da0a4fab15dc12c5741c1d4a9077d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b369c5893f6a3f48f64612719ba8418e808e5167debfbb433f800c8917c7bb2a"
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
