class Plutovg < Formula
  desc "Tiny 2D vector graphics library in C"
  homepage "https://github.com/sammycage/plutovg"
  url "https://github.com/sammycage/plutovg/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "2b0d17a6e016f47b86f9c00e2cb82600041b1ea1f7d2a00c2d46ae542cbfed3c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ba1963811e934ee5e50b058f92c139ee4d1d9870713e5583fd12196f9bb91bb2"
    sha256 cellar: :any,                 arm64_sequoia: "9dedd7db6202d75e290907b95cfaea5d02ebbf745633d99cc2acd303dec235af"
    sha256 cellar: :any,                 arm64_sonoma:  "f57ae1394dfe700a3181d668940bc4738fdd0d6b6930481e86cc5a6e18ed952a"
    sha256 cellar: :any,                 sonoma:        "5efc922a81720f185728b4b0b9ea52d6fafc348e572818514e5e7de2f93b0759"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45be05dd480ea03848f5fef76117b18b37bb0c51c4501ac49749d97b30f74121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69e2adf19de3e6651133968a6d3ae558ac3c228a696da0a21ac729d97bcd594a"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DPLUTOVG_BUILD_EXAMPLES=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"examples").install "examples/smiley.c"
  end

  test do
    system ENV.cc, pkgshare/"examples/smiley.c", "-o", "smiley", "-I#{include}/plutovg", "-L#{lib}", "-lplutovg"
    system testpath/"smiley"
    assert File.size("smiley.png").positive?
  end
end
