class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/v2.3.0.tar.gz"
  sha256 "d8dcc83f8e9686e6855da4c33d8c373f1735d87294edbd86ed662ba2f2f89277"
  license "BSD-2-Clause-Patent"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d3b57e128a6781ec6a929e59c90e15113ffaff44f922cb48aab82bbc7fb9524c"
    sha256 cellar: :any,                 arm64_big_sur:  "1977b1939d44b8871ef1d856203b364b761872be00c6654fdfd7c4edc53b7513"
    sha256 cellar: :any,                 monterey:       "0d75fe9a5ee9e1d98ef32302ccbb214bf5116b53533945f87114f7de17833d8d"
    sha256 cellar: :any,                 big_sur:        "8392899eaf6b8b44a5c2da81711928f69f1eb6ebcc2ceedd7552cb63d73e9b11"
    sha256 cellar: :any,                 catalina:       "f98f34e7b0950ef2599c7ec880114a58beb37c4eebe328cbaff29ed9e4f0e839"
    sha256 cellar: :any,                 mojave:         "d1fa30cd6767fb44fdd01d03877ec8fcbd7aa140a243d74b85eb3ab7c49391d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e9b2b1c38c6bf47985c77509bc5f6458a84d90e06cc9aac18459ce9b5f79726"
  end

  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build

  def install
    Dir.chdir("libvmaf") do
      system "meson", *std_meson_args, "build"
      system "ninja", "-vC", "build"
      system "ninja", "-vC", "build", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libvmaf/libvmaf.h>
      int main() {
        return 0;
      }
    EOS

    flags = [
      "-I#{HOMEBREW_PREFIX}/include/libvmaf",
      "-L#{lib}",
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
