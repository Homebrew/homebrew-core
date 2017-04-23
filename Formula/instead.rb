class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.syscall.ru/"
  url "https://github.com/instead-hub/instead/archive/3.0.0.tar.gz"
  sha256 "c31c38523b666a43d8f639c433b3e9b7470b38b300e94b718181493f575921e5"
  head "https://github.com/instead-hub/instead.git"

  bottle do
    sha256 "3e48bcfdbfb9ad1c6dba6ef8891e06d9fe6a0ca16a7aa3af0a847ae19caf81a0" => :sierra
    sha256 "b5689cfd9d9f6f2f57be7cd0d70f188a808d252d73ba098752a00abfc6a7d194" => :el_capitan
    sha256 "02232def2681a6b34c5d2efaf006d6d37cfeed5d7839cd52306ce3623696c764" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "lua"
  depends_on "sdl"
  depends_on "sdl_image"
  depends_on "sdl_mixer"
  depends_on "sdl_ttf"

  def install
    mkdir "build" do
      system "cmake", "..", "-DWITH_GTK2=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match /INSTEAD #{version} /, shell_output("#{bin}/instead -h 2>&1")
  end
end
