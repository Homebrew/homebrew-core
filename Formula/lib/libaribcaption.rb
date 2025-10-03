class Libaribcaption < Formula
  desc "Portable ARIB STD-B24 Caption Decoder/Renderer"
  homepage "https://github.com/xqq/libaribcaption"
  url "https://github.com/xqq/libaribcaption/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "278d03a0a662d00a46178afc64f32535ede2d78c603842b6fd1c55fa9cd44683"
  license "MIT"
  head "https://github.com/xqq/libaribcaption.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "9eb1e545807e31a3efb83df1e8af4c443a2443ad726ee59b3132e6a05b7d6159"
    sha256 cellar: :any,                 arm64_sequoia:  "ee6159957adc5a0d51c97ea3ff269abb39c5eafb0a8bddf7c14033827f22a6d0"
    sha256 cellar: :any,                 arm64_sonoma:   "350944da4a91c77f3a44925b3f563b97b763f71c9a3ca42d0a6a47d064f27a8c"
    sha256 cellar: :any,                 arm64_ventura:  "b4ed009d3d15f9b1ea86896330e05298282388ebaf4865d9629416d0ee61c27c"
    sha256 cellar: :any,                 arm64_monterey: "b36c2311bd81f867b0a7d901b583b037598319d96057f55ad20fd6140fbfc063"
    sha256 cellar: :any,                 sonoma:         "9789d6fea6f6dfd1443d067eec9591d3e67b0f68b724e2db60b0aae6ff77f605"
    sha256 cellar: :any,                 ventura:        "9c3435a993b489b7b25d02c1c586cc6df386fc1ad9d7563d5b46c84e26560430"
    sha256 cellar: :any,                 monterey:       "00512bb7e8fcb54f7b407a0eb1a32620dc364a0a87a6d78374bd9942a4ac4fe1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "84244a732beff5af9dd11ecc22abe0c05a665a091bbc98727f2b07a608439945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6f81f903e8e95519c2f783bc8749cf9513e684545230d518f445b8e407b8764"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DARIBCC_SHARED_LIBRARY=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aribcaption/decoder.h>

      int main(int argc, char *argv[]) {
        aribcc_context_t* ctx = aribcc_context_alloc();
        if (!ctx)
          return 1;
        aribcc_context_free(ctx);
        return 0;
      }
    C
    flags = shell_output("pkgconf --cflags --libs libaribcaption").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
