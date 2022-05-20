class Libsoundio < Formula
  desc "Cross-platform audio input and output"
  homepage "http://libsound.io"
  url "https://github.com/andrewrk/libsoundio/archive/2.0.0.tar.gz"
  sha256 "67a8fc1c9bef2b3704381bfb3fb3ce99e3952bc4fea2817729a7180fddf4a71e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b0f9dbada44ba4755bcdb77b1e795a2c986ffc12636dcc615dce885762aeab25"
    sha256 cellar: :any,                 arm64_big_sur:  "bddba449e4230b270c0e63b404ebb08bfd4d4b3d8eb3204295d09abffc1fa5fe"
    sha256 cellar: :any,                 monterey:       "084c3968367c608574a7aa073da607b48970d867bc0085846e41abe58dd1d291"
    sha256 cellar: :any,                 big_sur:        "3cd37146cfc412fe8ec53a9f39b41597899cf62929cf15f15efb80006a341d6a"
    sha256 cellar: :any,                 catalina:       "e7e22b9890d244052a61b62da42affa11750a3f1437d9a9c652f4ddb28f6253b"
    sha256 cellar: :any,                 mojave:         "628d236080adb8e63089ce94e4e723c5726128558d09d28d0691669b15ac765c"
    sha256 cellar: :any,                 high_sierra:    "7b24e3aad33f017119899e24c22ab7d94e6b96d87b10a4dc728e615530ee180e"
    sha256 cellar: :any,                 sierra:         "e0b25e880fb129834acc0e446499051bd1d0f9efecc4a9c32c82a77c9c54a378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee8c24a54b87cc5dde68241be4389bf6076a3f11a4653886b10f59d1bcac46f6"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <soundio/soundio.h>

      int main() {
        struct SoundIo *soundio = soundio_create();

        if (!soundio) { return 1; }
        if (soundio_connect(soundio)) return 1;

        soundio_flush_events(soundio);
        soundio_destroy(soundio);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lsoundio", "-o", "test"
    system "./test"
  end
end
