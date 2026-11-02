class LibheifPlugins < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.23.7/libheif-1.23.7.tar.gz"
  sha256 "f7483e818503ea6224c8863e4a56ac02c7089021a98472c811c12aa19faf2475"
  license "LGPL-3.0-or-later"
  revision 1

  livecheck do
    formula "libheif"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0beabe575689a0531303296d17925c9d74270783f3ea5af0fea34b2e68615385"
    sha256 cellar: :any, arm64_tahoe:       "449c8be285e324b9fc5d2c033c54003a944359e1d1c091d7b4f03023905da790"
    sha256 cellar: :any, arm64_sequoia:     "fab7377ddb8521ad6870064a90e907d6ef22b94551d7b25397776c14a64ee2d3"
    sha256 cellar: :any, arm64_linux:       "e629ae674bd5d987ec4ce2250a090148fea8700e43dedcb111a8e07045094f02"
    sha256 cellar: :any, x86_64_linux:      "a2eba99d589348879d9f2be8b0417c5d0b454cf9cde6db9ec3c74ce60fce3483"
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

  deny_network_access!
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
    libheif_bin = formula_opt_bin("libheif")
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
