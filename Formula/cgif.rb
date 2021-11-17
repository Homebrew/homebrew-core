class Cgif < Formula
  desc "GIF encoder written in C"
  homepage "https://github.com/dloebl/cgif"
  url "https://github.com/dloebl/cgif/archive/refs/tags/V0.0.2.tar.gz"
  sha256 "679e8012b9fe387086e6b3bcc42373dbc66fb26f8d070d7a1d23f39d42842258"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "37a952e3bdceba2490a846042d526d4fc1b9fc550865a98ec670b9e46060f2ea"
    sha256 cellar: :any,                 arm64_big_sur:  "13fbf5bc4a49d0fe9f1fd2b02e961180274c4703753f5e8dfef0273b85003d0b"
    sha256 cellar: :any,                 monterey:       "6169ac2485af5729821280290f17dbceb1fd544e17ce2540d7edda969d29f012"
    sha256 cellar: :any,                 big_sur:        "74c7063d8d5265c91d0ef45837ee70df58e17050f82936093c0e16eb0c3114f4"
    sha256 cellar: :any,                 catalina:       "11ab124fac3e15c9e9f2958fd5c48e3a197e084af14c339e137fc0b1ff584510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50ae94de0aed10ef206e9229f480453116f38f6e6421e9d5ff1ebed6d1d384e4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "..", "-Dtests=false"
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"try.c").write <<~EOS
      #include <cgif.h>
      int main() {
        CGIF_Config config = {0};
        CGIF *cgif;

        cgif = cgif_newgif(&config);

        return 0;
      }
    EOS
    system ENV.cc, "try.c", "-L#{lib}", "-lcgif", "-o", "try"
    system "./try"
  end
end
