class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://github.com/c-ares/c-ares/releases/download/v1.34.2/c-ares-1.34.2.tar.gz"
  sha256 "35410aa625cc9ee95b66475f54aea7c81c673fb63d75fad5eee267711503b72a"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "164c38ef6fa24a9704155546622c1b3b755b7dd8aacf56cdf101e36fac6c23b7"
    sha256 cellar: :any,                 arm64_sonoma:  "481d2f96a66a542f39bd37192f9fd301d025307d7e755834ccb14ea5f29202e3"
    sha256 cellar: :any,                 arm64_ventura: "7ef7b345a94de276439b3bb9ebd727bfc3031ae12482446dc17d4aa0035c655f"
    sha256 cellar: :any,                 sonoma:        "e5efe412ae88839b3b8fc40a98e08e6055f95d930900a3fb441f7fd0ce46fb02"
    sha256 cellar: :any,                 ventura:       "87f0125ec6810e87ac6201ffaf1b6267a309bdf5168ee7a83e42284d9b63aae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daff0241513357c2d3fb76227037258409c18433e5c4c506f6e31aaf4913a73b"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DCARES_STATIC=ON
      -DCARES_SHARED=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"

    system bin/"ahost", "127.0.0.1"
  end
end
