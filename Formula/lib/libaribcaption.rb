class Libaribcaption < Formula
  desc "Portable ARIB STD-B24 Caption Decoder/Renderer"
  homepage "https://github.com/xqq/libaribcaption"
  url "https://github.com/xqq/libaribcaption/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "6e4ff246155524e0e90d8657148b53e1322d5197d524e7b490bbee4ffcdc66c5"
  license "MIT"
  head "https://github.com/xqq/libaribcaption.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "95f26086bd7441422b937c1b5669c83949002748c830f6c9169d99b8607f798f"
    sha256 cellar: :any,                 arm64_monterey: "54e6fe96fd275bf48cd7855079e57f9db065b13236217d091672da5215d04d65"
    sha256 cellar: :any,                 arm64_big_sur:  "70938eafd08f1bdd3d350acc46a1cc2883d7bd7ab59443b8e4534978738f3469"
    sha256 cellar: :any,                 ventura:        "d98426fc8cf65f3a4b4c158e87502e011241027e407ba3e367d39b15b3b0bd92"
    sha256 cellar: :any,                 monterey:       "fabcf532d86466ffc3718a5be2aa9084ac0071832e859bb27dc4f9c589e7857e"
    sha256 cellar: :any,                 big_sur:        "3cfe6d592c479f2196544b2b364b967b2d87e62a07dbcbb61b094e05f1ae039f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f2162518abbdfb04a4b49310753e4e9df426f6fd83ba467ff8a725f049884f7"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "fontconfig"
    depends_on "freetype"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DARIBCC_SHARED_LIBRARY=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <aribcaption/decoder.h>

      int main(int argc, char *argv[]) {
        aribcc_context_t* ctx = aribcc_context_alloc();
        if (!ctx)
          return 1;
        aribcc_context_free(ctx);
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs libaribcaption").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
