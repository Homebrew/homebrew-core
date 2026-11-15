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
    sha256 cellar: :any, arm64_golden_gate: "d4dc196e0b515c875bda6a658eb440870490bfcc33c3f5e94c8ba16ff4715d7f"
    sha256 cellar: :any, arm64_tahoe:       "bdc5a65726583d24adcc7d7922d5d4ef2c5d2e5bdee1a6389c8f74ac5fc9ac16"
    sha256 cellar: :any, arm64_sequoia:     "bc39a9a63aeaad2434c493cb991e84377e16aba02f3d2fb266070a630cfd6d6e"
    sha256 cellar: :any, arm64_linux:       "7ed22f954ba8caed4c5ae7afcc5da67a8054f25b3a6afaf8febcb4b276315a54"
    sha256 cellar: :any, x86_64_linux:      "2d7de8bdaa19608345e9981aa8e99be2e537399d5dd9f84540ed60212b3d3b16"
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
