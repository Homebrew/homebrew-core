class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "https://gstreamer.freedesktop.org/modules/orc.html"
  url "https://gstreamer.freedesktop.org/src/orc/orc-0.4.42.tar.xz"
  sha256 "7ec912ab59af3cc97874c456a56a8ae1eec520c385ec447e8a102b2bd122c90c"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause"]

  livecheck do
    url "https://gstreamer.freedesktop.org/src/orc/"
    regex(/href=.*?orc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a45340cf95a072f37cb00f9bcb8b1dfe31128fe4a9421957c9a57938a87341a1"
    sha256 cellar: :any, arm64_sequoia: "7a0d9ba6e8e8279bc1c17502bb2384564ee63b8df3f0db9e2fdbc04084807713"
    sha256 cellar: :any, arm64_sonoma:  "cdf97de8164961de85d7f7b18b07b725770c767bd8ebd0bb3ec88c0c31381bc6"
    sha256 cellar: :any, sonoma:        "177f50d05d85775089fab59021fdbc7d483814f42558d170cd8f26d146512262"
    sha256               arm64_linux:   "f8b2f804f9e7cac847bc8d375976f29d9a6f3a1a78e2bedf91ce677d1801b5a5"
    sha256               x86_64_linux:  "f61c9e4d2bc4894d65d16c7ccedeba81ffaac9c07cbc337be00cd8d77d353c06"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/orcc --version 2>&1")

    (testpath/"test.c").write <<~C
      #include <orc/orc.h>

      int main(int argc, char *argv[]) {
        if (orc_version_string() == NULL) {
          return 1;
        }
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}/orc-0.4", "-L#{lib}", "-lorc-0.4", "-o", "test"
    system "./test"
  end
end
