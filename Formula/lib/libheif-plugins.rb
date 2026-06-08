class LibheifPlugins < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.23.0/libheif-1.23.0.tar.gz"
  sha256 "4c9182b18897617182eed12ab5eb9f9d855b3aa3a736d6bdb31abc034ec7d393"
  license "LGPL-3.0-or-later"

  livecheck do
    formula "libheif"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fb86b6c0f4590b33ab1301d44982f42d2e3073e4cd1ada1731cfc1272f57c664"
    sha256 cellar: :any, arm64_sequoia: "10494ce60f29272c883cb7ee85a9ed2e648f83e1978dc3af1ce8d9ce259b51b1"
    sha256 cellar: :any, arm64_sonoma:  "eea5f549371e8d7a098f03af7688ad126c911714458ef45be0ad9ec39c7f65e8"
    sha256 cellar: :any, sonoma:        "1739b638ce588bb2f2c49d37578931b325f7997b9e44219fc1dad40de223be79"
    sha256 cellar: :any, arm64_linux:   "bd8084337d91b2686c42d97768d2a450a21ad93c3188e4d62ec742a98ec6976b"
    sha256 cellar: :any, x86_64_linux:  "bc38c2b7f9b4c300e3e622fcd755e0f0fff280977c0ceea1c96578f33ce89281"
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

    system libheif_bin/"heif-enc", test_fixtures("test.jpg"), "--htj2k", "--output", "test.hej2"
    assert_match "MIME type: image/hej2k", shell_output("#{libheif_bin}/heif-info test.hej2")
  end
end
