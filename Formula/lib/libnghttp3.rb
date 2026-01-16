class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://github.com/ngtcp2/nghttp3/releases/download/v1.14.0/nghttp3-1.14.0.tar.xz"
  mirror "http://fresh-center.net/linux/www/nghttp3-1.14.0.tar.xz"
  sha256 "b3083dae2ff30cf00d24d5fedd432479532c7b17d993d384103527b36c1ec82d"
  license "MIT"
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a4dd6f6ca919f4f6d1ca644f0305974489c049d51242103c05821b6a8538d686"
    sha256 cellar: :any,                 arm64_sequoia: "7cbf5487da129350ab703d9e49968c66d2c0b6a1563d5476e5e409750eaed2da"
    sha256 cellar: :any,                 arm64_sonoma:  "a7995f5700354aa6602f4cfbbdaa605ee1fd74f7197b61897367495bdbd7eb1e"
    sha256 cellar: :any,                 sonoma:        "6690c2c4ccbb545555eef72c67bf0a8343cf7c5af437263b4ca17750fc2c43de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49523163dbc0df17cf7714cbabea224370a7eaddc33141759bc91c4d46ef9b85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e432071217b56f03efd8a482771b30d56bf2ec663985291278b12256576ec13"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DENABLE_LIB_ONLY=1", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <nghttp3/nghttp3.h>

      int main(void) {
        nghttp3_qpack_decoder *decoder;
        if (nghttp3_qpack_decoder_new(&decoder, 4096, 0, nghttp3_mem_default()) != 0) {
          return 1;
        }
        nghttp3_qpack_decoder_del(decoder);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lnghttp3"
    system "./test"
  end
end
