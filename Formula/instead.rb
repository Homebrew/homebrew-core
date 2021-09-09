class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.hugeping.ru/"
  url "https://github.com/instead-hub/instead/archive/3.4.1.tar.gz"
  sha256 "8e61b931df2076382fe2a6857478d1d234e46db907390697656ad6754583793e"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "45d232888010f08061c538508284c8ab88fa32cedf4ecbf40b23185caee9627b"
    sha256 big_sur:       "ddf0324ef2021262ccc7eb7684a14369e247a9f089ec9dfadcba4a263ae040ff"
    sha256 catalina:      "7c936d16151915bcf9074abbeeebdf01125219c96946b1852b39826de34309b9"
    sha256 mojave:        "1d8cb0f60159c4573c2bbc17e71ab7d878466e105a2a785bb598a51b9da1c962"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "luajit-openresty"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  def install
    luajit = Formula["luajit-openresty"]
    mkdir "build" do
      system "cmake", "..", "-DWITH_GTK2=OFF",
                            "-DWITH_LUAJIT=ON",
                            "-DLUA_INCLUDE_DIR=#{luajit.opt_include}/luajit-2.1",
                            "-DLUA_LIBRARY=#{luajit.opt_lib}/#{shared_library("libluajit")}",
                            *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "INSTEAD #{version} ", shell_output("#{bin}/instead -h 2>&1")
  end
end
