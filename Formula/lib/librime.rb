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
  depends_on "pkgconf" => :build

  depends_on "lua"

  resource "lua" do
    url "https://github.com/hchunhui/librime-lua.git", branch: "master"
  end

  resource "octagram" do
    url "https://github.com/lotem/librime-octagram.git", branch: "master"
  end

  resource "predict" do
    url "https://github.com/rime/librime-predict.git", branch: "master"
  end

  def install
    resources.each do |r|
      r.stage buildpath/"plugins"/r.name
    end

    # TODO: Dependents should moved to `depends_on` block, but it is not work now
    system "make", "deps"
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_MERGED_PLUGINS=OFF",
                    "-DBUILD_TEST=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DENABLE_EXTERNAL_PLUGINS=ON",
                    *std_cmake_args
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
