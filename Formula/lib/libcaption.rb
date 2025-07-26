class Libcaption < Formula
  desc "Free open-source CEA608 / CEA708 closed-caption encoder/decoder"
  homepage "https://github.com/szatmary/libcaption"
  # Maintainer of the repo hasn't tagged the latest commit, so we use a specific commit hash.
  url "https://github.com/szatmary/libcaption/archive/e8b6261090eb3f2012427cc6b151c923f82453db.tar.gz"
  version "0.8"
  sha256 "ed867b4d54ca06b88f3fab23ee3feeecff1d277d8d5c16a56741286d3ae309ec"
  license "MIT"
  head "https://github.com/szatmary/libcaption.git", branch: "develop"

  depends_on "cmake" => :build

  def install
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_EXAMPLES=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <caption/cea708.h>
      int main(void) {
        caption_frame_t ccframe;
        caption_frame_init(&ccframe);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcaption", "-o", "test"
    system "./test"
  end
end
