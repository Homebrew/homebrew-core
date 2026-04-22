class LibheifPlugins < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.21.2/libheif-1.21.2.tar.gz"
  sha256 "75f530b7154bc93e7ecf846edfc0416bf5f490612de8c45983c36385aa742b42"
  license "LGPL-3.0-or-later"
  revision 1

  livecheck do
    formula "libheif"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "0d9bccc7072aaaf77988007f79892ec328223a3c52ce98bd131062396262bd61"
    sha256 cellar: :any,                 arm64_sequoia: "c804164c3051aea8a9b0a6cda54472c7bb439d29180a6e989fe804c0b1cf326c"
    sha256 cellar: :any,                 arm64_sonoma:  "a609d2bbc1e0acc31d03a9e03f6d5bded018abd772d1ba2390fb5b50e47f9518"
    sha256 cellar: :any,                 sonoma:        "98c82781feb7d2714c7c616ae492388491b6bd29408b4e9b78c88b254ff64084"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "195d6ca06f71450c988a50fc85b6a6fccf286cc15b01205d7da3e9e64e489ef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90030cd3863008c831c21f319597dcca6c8afafa682ffbe1b9b28a5d2cbee794"
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

  # Backport support for svt-av1 >= 4
  patch do
    url "https://github.com/strukturag/libheif/commit/2a7a383ffe90a5d36d7e0c939e6a7ae953e6ba55.patch?full_index=1"
    sha256 "bd56a238a476713b91448209a0cbe4d9c2c79aeb1965e1226fc9e915851f956b"
  end
  patch do
    url "https://github.com/strukturag/libheif/commit/fa38577416b743346c315d957becc90b269de2ee.patch?full_index=1"
    sha256 "f3e9fb2a7e5e430f16f49b520b8dca1eb877ab42060d2294e7ce4793813cc149"
  end

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
      -DCMAKE_INSTALL_RPATH=#{rpath(source: lib/"libheif", target: Formula["libheif"].opt_lib)}
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

    system libheif_bin/"heif-enc", test_fixtures("test.jpg"), "--output", "test.hej2"
    assert_match "MIME type: image/hej2k", shell_output("#{libheif_bin}/heif-info test.hej2")
  end
end
