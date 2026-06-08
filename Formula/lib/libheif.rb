class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.23.0/libheif-1.23.0.tar.gz"
  sha256 "4c9182b18897617182eed12ab5eb9f9d855b3aa3a736d6bdb31abc034ec7d393"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "be8afc171ac0b6b023710f5da93c469cfe918a9f01d62a903cb40489f05fcf7c"
    sha256 cellar: :any, arm64_sequoia: "c363bd0ad8e834979b344c858e354e7d996fd22b8d129c214e339b127a9dd14b"
    sha256 cellar: :any, arm64_sonoma:  "14f4b5746bfe1ff5f7a14d28ad398e22ea9700ced3e279b5b4f19b51765681ff"
    sha256 cellar: :any, sonoma:        "bc69b5e3763a9991be266e3fc722e90d4c9a3d72e0ab92675974c168cb86635f"
    sha256 cellar: :any, arm64_linux:   "a0584d08001171587d6468dea8e2f711abbf0f6db14d4588b305886922003ffd"
    sha256 cellar: :any, x86_64_linux:  "13ff4f29d446e1b3bee7c1c07fc1d026914ce2922d6fd43bb8fd0fbbed5f8a7d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "aom"
  depends_on "jpeg-turbo"
  depends_on "libde265"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "webp"
  depends_on "x265"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPLUGIN_DIRECTORY=#{HOMEBREW_PREFIX}/lib/libheif
      -DPLUGIN_INSTALL_DIRECTORY=#{lib}/libheif
      -DWITH_DAV1D=OFF
      -DWITH_EXAMPLE_HEIF_VIEW=OFF
      -DWITH_GDK_PIXBUF=OFF
      -DWITH_OpenH264_DECODER=OFF
      -DWITH_RAV1E=OFF
      -DWITH_SvtEnc=OFF
      -DWITH_X264=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/example.heic"
    pkgshare.install "examples/example.avif"

    system "cmake", "-S", ".", "-B", "static", *args, *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "static"
    lib.install "static/libheif/libheif.a"

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace lib/"pkgconfig/libheif.pc", prefix, opt_prefix
  end

  def caveats
    "Additional codecs can be enabled by `brew install libheif-plugins`"
  end

  test do
    output = "File contains 2 images"
    example = pkgshare/"example.heic"
    exout = testpath/"exampleheic.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_path_exists testpath/"exampleheic-1.jpg"
    assert_path_exists testpath/"exampleheic-2.jpg"

    output = "File contains 1 image"
    example = pkgshare/"example.avif"
    exout = testpath/"exampleavif.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_path_exists testpath/"exampleavif.jpg"
  end
end
