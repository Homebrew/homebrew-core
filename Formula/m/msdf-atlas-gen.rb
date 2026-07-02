class MsdfAtlasGen < Formula
  desc "Generator of multi-channel signed distance field atlases from fonts"
  homepage "https://github.com/Chlumsky/msdf-atlas-gen"
  url "https://github.com/Chlumsky/msdf-atlas-gen/archive/refs/tags/v1.4.tar.gz"
  sha256 "57db9548b30905b18640ceab5011144e9d362f33a53748bef6be53dd743c9992"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "msdfgen"
  depends_on "tinyxml2"

  # NOTES:
  # - Artery Font export is disabled. It is a header-only submodule which does
  #   not ship in the release tarball.
  # - CMAKE_CXX_STANDARD=17 disambiguates a BitmapConstSection conversion
  #   which allows this to build with msdfgen v1.13. Can be dropped in the next
  #   version. See: https://github.com/Chlumsky/msdfgen/issues/253
  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DMSDF_ATLAS_USE_VCPKG=OFF",
           "-DMSDF_ATLAS_MSDFGEN_EXTERNAL=ON",
           "-DMSDF_ATLAS_USE_SKIA=OFF",
           "-DMSDF_ATLAS_NO_ARTERY_FONT=ON",
           "-DMSDF_ATLAS_INSTALL=ON",
           "-DCMAKE_CXX_STANDARD=17",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    if OS.mac?
      font_name = "Arial Unicode.ttf"
      font_dir = "/Library/Fonts"
    else
      font_name = "DejaVuSans.ttf"
      font_dir = "/usr/share/fonts/truetype/dejavu"
    end
    cp "#{font_dir}/#{font_name}", testpath

    system bin/"msdf-atlas-gen", "-font", font_name, "-type", "msdf",
           "-size", "24", "-imageout", "atlas.png", "-json", "atlas.json"
    assert_path_exists testpath/"atlas.png"
    assert_path_exists testpath/"atlas.json"
    assert_equal "\x89PNG\r\n\x1a\n".b, File.binread(testpath/"atlas.png", 8)
    assert_match(/"atlas"/, File.read(testpath/"atlas.json"))
  end
end
