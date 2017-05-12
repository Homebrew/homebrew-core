class Darktable < Formula
  desc "Open source photography workflow application and raw developer"
  homepage "https://www.darktable.org"
  url "https://github.com/darktable-org/darktable/releases/download/release-2.2.4/darktable-2.2.4.tar.xz"
  sha256 "bd5445d6b81fc3288fb07362870e24bb0b5378cacad2c6e6602e32de676bf9d8"

  needs :openmp

  depends_on "cmake"    => :build
  depends_on "intltool" => :build
  depends_on "jpeg"
  depends_on "desktop-file-utils"
  depends_on "exiv2"
  depends_on "flickcurl"
  depends_on "gcc"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gphoto2"
  depends_on "graphicsmagick" => :optional
  depends_on "gtk+3"
  depends_on "gtk-mac-integration"
  depends_on "json-glib"
  depends_on "lensfun"
  depends_on "librsvg"
  depends_on "libsecret"
  depends_on "libsoup"
  depends_on "little-cms2"
  depends_on "lua"
  depends_on "ninja"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "osm-gps-map"
  depends_on "pugixml"

  fails_with "gcc" => 6
  fails_with "gcc" => 7

  resource "raw_sample" do
    url "https://raw.pixls.us/getfile.php/1033/nice/homebrew.raw"
    sha256 "b22f1e36331f679abb8b13e433b9bbde3988723adf10fee7aa0dda6381016a98"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    testpath.install resource("raw_sample")

    %w(jpg tif png exr webp j2k pfm ppm).each do |extension|
      expected_file = "image.#{extension}"
      system bin/"darktable-cli", "homebrew.raw", "-o", expected_file
      assert File.size?(expected_file)
    end

    expected_string = "Hello Homebrew world!"
    lua_code = <<-EOL
    dt = require "darktable"
    dt.print("#{expected_string}")
    EOL

    stdout = shell_output(bin/"darktable-cli homebrew.raw -o image_lua_test.jpg --core --luacmd '#{lua_code}'", 0)
    assert_match expected_string, stdout
  end
end
