class LibheifPlugins < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.21.2/libheif-1.21.2.tar.gz"
  sha256 "75f530b7154bc93e7ecf846edfc0416bf5f490612de8c45983c36385aa742b42"
  license "LGPL-3.0-or-later"

  livecheck do
    formula "libheif"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0ccc7b2af34db11f2d26cfeb648aad0eb3b678f578db9214a9705a9e29dd0dc9"
    sha256 cellar: :any,                 arm64_sequoia: "acbef028864691f20d183f7c8b1341aa620e9a4601961fb8effdf6ebbe83685a"
    sha256 cellar: :any,                 arm64_sonoma:  "a8b403f15c0463b38fba2ee2108d1304a45d03c084c66264d348d91a64828bdb"
    sha256 cellar: :any,                 sonoma:        "6f6994b81ff3ff859fc397535cd8ad92038004ab8460844e11bd596679fecec5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74ca2429f3488300a594dd29d3968ace62a9e9ac2569296f4557e76408550325"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4df5d2565c25cbd0443ea243431a2c3f2bfa13f76114a8573b18d7d90d55c0e"
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
  depends_on "x264"

  def install
    # Enabling plugins for "popular" formulae
    # TODO: Add `SvtEnc` (svt-av1) when new release is compatible
    plugins = %w[
      DAV1D
      FFMPEG_DECODER
      JPEG_DECODER
      JPEG_ENCODER
      OpenJPEG_DECODER
      OpenJPEG_ENCODER
      OPENJPH_ENCODER
      RAV1E
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
