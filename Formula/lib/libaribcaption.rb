class Libaribcaption < Formula
  desc "Portable ARIB STD-B24 Caption Decoder/Renderer"
  homepage "https://github.com/xqq/libaribcaption"
  url "https://github.com/xqq/libaribcaption/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "649b50bde99272b97c66af2a8400163e2f84eae072d252daa26baaaf0866a1c2"
  license "MIT"
  head "https://github.com/xqq/libaribcaption.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dfbd01f66719cce8fe72f86c9c8ef7930157749a8da659b6bcfd27f906aa2ba9"
    sha256 cellar: :any, arm64_sequoia: "e7d83828ac59fcff10aff4435be198fd6c6d9b812c982ba28359bb708f40bade"
    sha256 cellar: :any, arm64_sonoma:  "66eb6eff4f7469d951dad362a68375178a48794c0a230e10525e2552bc4726b3"
    sha256 cellar: :any, sonoma:        "3eacfcff63e0080dc1430c1f3b69c62ec571a7ce4ccf72b5ab8f66ed403d4f63"
    sha256 cellar: :any, arm64_linux:   "b395f8fb41ffac3fd8fb40c19555a23eeafbbc85ce645e5d0f7118a7de8d4a82"
    sha256 cellar: :any, x86_64_linux:  "14d9ef888a91d5c3c63d6fbe2be4fcaebf9f5e553674ac0a5c07250aaa35e9b5"
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
