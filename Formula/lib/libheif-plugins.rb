class LibheifPlugins < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.23.1/libheif-1.23.1.tar.gz"
  sha256 "0de0327f60fcd47de90d5654c6fe152232738d60d84fe084ec3e0f35e03b166a"
  license "LGPL-3.0-or-later"

  livecheck do
    formula "libheif"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f225475c6f80f0ef746c07012d5ccdc9a13f12a25c7f7de5680b3544218d99f1"
    sha256 cellar: :any, arm64_sequoia: "2fb1ad8dae054e8f962eefc591ffdec392ebe63d36d1f46657200f378f0523e9"
    sha256 cellar: :any, arm64_sonoma:  "88e9c16b033120b06dc4939950ed2f2d3e3f8a6f792850deecb2ea79748cd852"
    sha256 cellar: :any, sonoma:        "94aa591367115264ee65489bb984235d8ace9d3027c1de10b961281344a0b60d"
    sha256 cellar: :any, arm64_linux:   "81580e86e8251dae97943c358425f424817ef31b21bd3b995ff6b4f776617403"
    sha256 cellar: :any, x86_64_linux:  "6cec5147f7466f5ebd60859275cb2257eda62aa99f497a8cd12ba071899a812c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "dav1d"
  depends_on "ffmpeg"
  depends_on "jpeg-turbo"
  depends_on "libheif"
  depends_on "openjpeg"
  depends_on "openjph"
  depends_on "rav1e"
  depends_on "svt-av1"
  depends_on "x264"

  def install
    # Enabling plugins for "popular" formulae
    plugins = %w[
      DAV1D
      FFMPEG_DECODER
      JPEG_DECODER
      JPEG_ENCODER
      OpenJPEG_DECODER
      OpenJPEG_ENCODER
      OPENJPH_ENCODER
      RAV1E
      SvtEnc
      X264
    ]

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath(source: lib/"libheif", target: formula_opt_lib("libheif"))}
      -DPLUGIN_DIRECTORY=#{HOMEBREW_PREFIX}/lib/libheif
      -DPLUGIN_INSTALL_DIRECTORY=#{lib}/libheif
      -DWITH_AOM_DECODER=OFF
      -DWITH_AOM_ENCODER=OFF
      -DWITH_EXAMPLES=OFF
      -DWITH_GDK_PIXBUF=OFF
      -DWITH_LIBDE265=OFF
      -DWITH_OpenH264_DECODER=OFF
      -DWITH_X265=OFF
    ] + plugins.flat_map { |plugin| ["-DWITH_#{plugin}=ON", "-DWITH_#{plugin}_PLUGIN=ON"] }

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build/libheif/plugins"
    system "cmake", "--install", "build/libheif/plugins"
  end

  test do
    libheif_bin = Formula["libheif"].bin
    decoders = shell_output("#{libheif_bin}/heif-dec --list-decoders")
    encoders = shell_output("#{libheif_bin}/heif-enc --list-encoders")

    %w[dav1d ffmpeg libjpeg-turbo openjpeg].each do |decoder|
      assert_match decoder, decoders
    end
    %w[libjpeg-turbo openjpeg openjph rav1e x264].each do |encoder|
      assert_match encoder, encoders
    end

    system libheif_bin/"heif-enc", test_fixtures("test.jpg"), "--htj2k", "--output", "test.hej2"
    assert_match "MIME type: image/hej2k", shell_output("#{libheif_bin}/heif-info test.hej2")
  end
end
