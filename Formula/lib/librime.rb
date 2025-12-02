class Librime < Formula
  desc "Rime Input Method Engine"
  homepage "https://rime.im"
  url "https://github.com/rime/librime.git",
      tag:      "1.15.0",
      revision: "75bc43ae9acdd2042d150a8c446e9ac8b6d77c84"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "453f97143d1fa1c6a2b4a5837c14685f9d4d5a2ad040b0ca76c3b3ec6ed2043b"
    sha256 cellar: :any,                 arm64_sequoia: "f2e1d1080fcfec4f0fd1014f84adf902aca76f5ba9cb0505e43d8c685106c17c"
    sha256 cellar: :any,                 arm64_sonoma:  "fcd170e7ae810b3fc34f7f0d875b3d9737687f0d8c435e374c10cf24252a1a8b"
    sha256 cellar: :any,                 sonoma:        "9ce2b76704dc59cda19110db331d699b3b02683a53a921b8250e291ec67950ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f37c17f936d21fc3e5b4154a9d913133d417c18023e9f2b8dc4e8dee12021976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d685f06241ac45ec5301c86cff62a75aaf772fcf7b4affef75c3d8590ee64c3b"
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
