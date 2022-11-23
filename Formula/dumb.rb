class Dumb < Formula
  desc "IT, XM, S3M and MOD player library"
  homepage "https://dumb.sourceforge.io"
  url "https://github.com/kode54/dumb/archive/refs/tags/2.0.3.tar.gz"
  sha256 "99bfac926aeb8d476562303312d9f47fd05b43803050cd889b44da34a9b2a4f9"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6ec724316f7ab409767fdb3b240bf6bd00c0753a66ea048b1a1527c19b659a6f"
    sha256 cellar: :any,                 arm64_monterey: "f046a0784378b98ac76156a7a5c306a8c4d931130309c64d6205b1bfd2d0dcfe"
    sha256 cellar: :any,                 arm64_big_sur:  "94dd00c18fd4f11400f30074357c4979fe727f49df6e45ad457e79a51d801f46"
    sha256 cellar: :any,                 ventura:        "e2acfd0a2255bdb9c7256cd9cec4bf7a450e3db8853271a2ad0e13befc4bac4b"
    sha256 cellar: :any,                 monterey:       "a0933282bbe2feb52a06cac1a1a189b83af422e422036f78b0fcfa0e55f5726c"
    sha256 cellar: :any,                 big_sur:        "2dade8ff6646f71df07f3b2d586c9bb49ae24c3f0b5ddddea7a09a3762501f5c"
    sha256 cellar: :any,                 catalina:       "f9d0768b3b50614adfb2190899362e250f20a14be0fb0c2d21d37bee0afea672"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de4310947cbbc1807cf9c2bbdb9dcc42cc381de7153b3dc4f206718a1923fe40"
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "sdl2"

  def install
    args = std_cmake_args + %w[
      -DBUILD_ALLEGRO4=OFF
      -DBUILD_EXAMPLES=ON
    ]

    # Build shared library
    system "cmake", "-S", ".", "-B", "build", *args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Build static library
    system "cmake", "-S", ".", "-B", "build", *args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build"
    lib.install "build/libdumb.a"
  end

  test do
    assert_match "missing option <file>", shell_output("#{bin}/dumbplay 2>&1", 1)
  end
end
