class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.21.2/libheif-1.21.2.tar.gz"
  sha256 "75f530b7154bc93e7ecf846edfc0416bf5f490612de8c45983c36385aa742b42"
  license "LGPL-3.0-only"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "af35c3d2f410ad34259b563c7035046fec87d79742e4553d0fc320320ad3704a"
    sha256 cellar: :any,                 arm64_sequoia: "a430779bd65fb58f2df5376026778715a914586bfc33eac7cfb241448d005b2b"
    sha256 cellar: :any,                 arm64_sonoma:  "af7b1b63237a51c44c051132b9f6192c4e0a2bc01bbc3102f56c30a66ee2aced"
    sha256 cellar: :any,                 sonoma:        "ecca71e02cd48a1a93d0de63615740a87bd519c41f5edbb081ce77d65ae64d93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51511c8e9db12403542684a1d879b41a4ba9d7996e9584cd7949f5a08e9db0f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e21d6132fbc71fac055316d01347d5691bde547a022716a0f07f97071b08403"
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
      -DWITH_DAV1D=OFF
      -DWITH_GDK_PIXBUF=OFF
      -DWITH_RAV1E=OFF
      -DWITH_SvtEnc=OFF
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
