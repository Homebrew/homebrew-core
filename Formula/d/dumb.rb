class Dumb < Formula
  desc "IT, XM, S3M and MOD player library"
  homepage "https://dumb.sourceforge.net/"
  url "https://github.com/kode54/dumb/archive/refs/tags/2.0.3.tar.gz"
  sha256 "99bfac926aeb8d476562303312d9f47fd05b43803050cd889b44da34a9b2a4f9"
  # Essentially Zlib but with modified and added clauses that aren't intended to restrict usage
  # https://src.fedoraproject.org/rpms/dumb/blob/rawhide/f/license-clarification.eml
  license :cannot_represent

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "d04fae5e3adcd02d608e3f3b8238a5702b0e74ab1c295128f3e65af4f494e3f4"
    sha256 cellar: :any,                 arm64_sequoia:  "7158a40eed75a578dd615fdf83840be91a4fd565b0ce5170c4e91d494e0a0a16"
    sha256 cellar: :any,                 arm64_sonoma:   "f9510e55b969457e77567594f6963a7a6470f86dac7f252ed3c01757314c44dd"
    sha256 cellar: :any,                 arm64_ventura:  "6ec724316f7ab409767fdb3b240bf6bd00c0753a66ea048b1a1527c19b659a6f"
    sha256 cellar: :any,                 arm64_monterey: "f046a0784378b98ac76156a7a5c306a8c4d931130309c64d6205b1bfd2d0dcfe"
    sha256 cellar: :any,                 arm64_big_sur:  "94dd00c18fd4f11400f30074357c4979fe727f49df6e45ad457e79a51d801f46"
    sha256 cellar: :any,                 sonoma:         "f7a07476417a15b6e5b5e67ba81dd7ea10d00c02a11d7d290fce803da9f399a1"
    sha256 cellar: :any,                 ventura:        "e2acfd0a2255bdb9c7256cd9cec4bf7a450e3db8853271a2ad0e13befc4bac4b"
    sha256 cellar: :any,                 monterey:       "a0933282bbe2feb52a06cac1a1a189b83af422e422036f78b0fcfa0e55f5726c"
    sha256 cellar: :any,                 big_sur:        "2dade8ff6646f71df07f3b2d586c9bb49ae24c3f0b5ddddea7a09a3762501f5c"
    sha256 cellar: :any,                 catalina:       "f9d0768b3b50614adfb2190899362e250f20a14be0fb0c2d21d37bee0afea672"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "040bc8a1b4387d297c3c83f33fc68f79b885a4fe0530e9ce9c70257f38faadc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de4310947cbbc1807cf9c2bbdb9dcc42cc381de7153b3dc4f206718a1923fe40"
  end

  deprecate! date: "2025-07-03", because: :repo_archived

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "sdl2"

  def install
    args = std_cmake_args + %w[
      -DBUILD_ALLEGRO4=OFF
      -DBUILD_EXAMPLES=ON
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
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
