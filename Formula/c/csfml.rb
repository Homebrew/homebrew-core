class Csfml < Formula
  desc "SMFL bindings for C"
  homepage "https://www.sfml-dev.org/"
  url "https://github.com/SFML/CSFML/archive/refs/tags/3.0.0.tar.gz"
  sha256 "903cd4a782fb0b233f732dc5b37861b552998e93ae8f268c40bd4ce50b2e88ca"
  license "Zlib"
  head "https://github.com/SFML/CSFML.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "079033bd42bdbbc6d32540f4cdd0d6d4edd734e2dd2b3b29221ca1302e8b88f6"
    sha256 cellar: :any,                 arm64_sequoia: "5908757a15a2ce67c4c38c47fdcad0dbdd9ab3eb3b4b3f9cd82e94ad70028cfa"
    sha256 cellar: :any,                 arm64_sonoma:  "8b6e300e881791159f17fc8f0408a1186098ff0c998c098f19ce04a8ced46fa6"
    sha256 cellar: :any,                 sonoma:        "9edacf0a72a2a907a76ee25e8a05ef1a1ab9dcab14f31bbea0a93d319d882429"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "322b12666dc4b5c0f017f359146b95c6b8efa87a2c234ee9a22af3da326febba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e25efc33ea956ec8be19658b2b82b81cafcd1c971b493e25258b4f8bf4a42b2"
  end

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <CSFML/Window/Window.h>

      int main()
      {
          sfVideoMode m = {800, 600, 32};
          sfWindow* w = sfWindow_create(m, "csfml", sfClose, sfWindowed, NULL);

          while (sfWindow_isOpen(w))
          {
              sfEvent e;
              sfWindow_pollEvent(w, &e);
              sfWindow_close(w);
          }

          sfWindow_destroy(w);
          return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lcsfml-window", "-o", "test"
    # Disable this part of the test on Linux because display is not available.
    system "./test" if OS.mac?
  end
end
