class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.19.tar.xz"
  sha256 "158aad4c2278ab08e76a3f2b0166c99b39fae00ee17231bd225c5a36e977a189"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/MusicPlayerDaemon/libmpdclient.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ff2e2dead72db65e09843a2aba5544c9433b99c66ece05090ebd91d2271b3290"
    sha256 cellar: :any,                 arm64_big_sur:  "b703e7d52c1be39561ae59034cd4574c6a9ef4a06cd98416503a402b01f7cf7a"
    sha256 cellar: :any,                 monterey:       "4563058613fd0d8265d19259e825dafde7cfc6ee646911ac9632aa01ad177400"
    sha256 cellar: :any,                 big_sur:        "ee86de4f5298b45cff0b1ba7446a9d9864fd1752184de585bf05e43a16374708"
    sha256 cellar: :any,                 catalina:       "866e94308617552de97ecb04f824408fa4f849d1ef79ff9bf5467170c80e3a23"
    sha256 cellar: :any,                 mojave:         "0db8f7c9e7cd6eb5082397e9270989864042e36c187cba2fa61ae43ca996e32f"
    sha256 cellar: :any,                 high_sierra:    "71c37d5af98688decfe4440ce87e267064a4a71e0b1a4e11455068b5127edae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96f6b9b1aec66edeb1646d5bea33cf109c7a46feacde6eecf9dea5653ccb95eb"
  end

  depends_on "doxygen" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", *std_meson_args, ".", "output"
    system "ninja", "-C", "output"
    system "ninja", "-C", "output", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mpd/client.h>
      int main() {
        mpd_connection_new(NULL, 0, 30000);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lmpdclient", "-o", "test"
    system "./test"
  end
end
