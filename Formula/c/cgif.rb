class Cgif < Formula
  desc "GIF encoder written in C"
  homepage "https://github.com/dloebl/cgif"
  url "https://github.com/dloebl/cgif/archive/refs/tags/V0.3.2.tar.gz"
  sha256 "0abf83b7617f4793d9ab3a4d581f4e8d7548b56a29e3f95b0505f842cbfd7f95"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4e6c51ed35b99250229cef7f20daf3b08b7b6b5cadea18f8df12c20fa73e47e9"
    sha256 cellar: :any,                 arm64_ventura:  "9754acc56bad6ac860426b26416b054f6fa0c3f3fb92df44fef7bfc933232948"
    sha256 cellar: :any,                 arm64_monterey: "ddaac31aa612f36c1192a518a546bb6b64dbac0327ff7571575e63e8b552de86"
    sha256 cellar: :any,                 arm64_big_sur:  "bd3124adb113fb95348ec27fba0defe7e30823a4630901566604e6d929193742"
    sha256 cellar: :any,                 sonoma:         "751355b69f8338d7252df49c8fc8c6289a17148da57722e59cdf427f39836699"
    sha256 cellar: :any,                 ventura:        "494c846242161c61eb911c482c984ad49e30725ada0c5e3c2961c5935abe08df"
    sha256 cellar: :any,                 monterey:       "662949bcf54a19a8ea72d24b36ddaf7c97485b17c6d5707c56edb8e0134073ec"
    sha256 cellar: :any,                 big_sur:        "e2832d3033308fce265b9a3f96d23ce2c205b433b79079acdc6fdca88757438c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55f47f42f7ef7d4336ff14703c9dda79d2b083d1e3d3d282b1ef316831e9bd77"
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
