class MsdfAtlasGen < Formula
  desc "Generator of multi-channel signed distance field atlases from fonts"
  homepage "https://github.com/Chlumsky/msdf-atlas-gen"
  url "https://github.com/Chlumsky/msdf-atlas-gen/archive/refs/tags/v1.4.tar.gz"
  sha256 "57db9548b30905b18640ceab5011144e9d362f33a53748bef6be53dd743c9992"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bc864ee7ffd2ae89c88dd047c727e44fa6b108cb170e4b6d1d81940f1b1b593d"
    sha256 cellar: :any, arm64_sequoia: "dc4c4069761d4f47b105f0ce5cc0305a09b0a98fa12e42860a584842f58e68d3"
    sha256 cellar: :any, arm64_sonoma:  "1b1a74c98eeb008f927c1ac0f9a6bbc52e8496776c432036f3d4151b7c97399a"
    sha256 cellar: :any, sonoma:        "624c0c4f6b14110e9f471c9c4819514a42990aa11e463b0082507e22ebdf1da1"
    sha256 cellar: :any, arm64_linux:   "4bdcb5e2803790c8feb98a3637b1d4bdfb4f894c9fb32bde1d2e71b6fb65799a"
    sha256 cellar: :any, x86_64_linux:  "0743b1556ee469a4e9acb87c339c8d1dd74f1d7fb4e53b7b0c9e7550b16dedf2"
  end

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "msdfgen"
  depends_on "tinyxml2"

  def install
    args = %w[
      -DMSDF_ATLAS_USE_VCPKG=OFF
      -DMSDF_ATLAS_MSDFGEN_EXTERNAL=ON
      -DMSDF_ATLAS_USE_SKIA=OFF
      -DMSDF_ATLAS_NO_ARTERY_FONT=ON
      -DMSDF_ATLAS_INSTALL=ON
      -DCMAKE_CXX_STANDARD=17
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    font_name, font_dir = if OS.mac?
      ["Arial Unicode.ttf", "/Library/Fonts"]
    else
      ["DejaVuSans.ttf", "/usr/share/fonts/truetype/dejavu"]
    end
    cp "#{font_dir}/#{font_name}", testpath

    system bin/"msdf-atlas-gen", "-font", font_name, "-type", "msdf", "-size", "24",
                                 "-imageout", "atlas.png", "-json", "atlas.json"
    assert_path_exists testpath/"atlas.png"
    assert_path_exists testpath/"atlas.json"

    assert_equal "\x89PNG\r\n\x1a\n".b, (testpath/"atlas.png").binread(8)
    assert_match "atlas", (testpath/"atlas.json").read
  end
end
