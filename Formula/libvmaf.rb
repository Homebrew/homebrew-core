class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/v2.3.0.tar.gz"
  sha256 "d8dcc83f8e9686e6855da4c33d8c373f1735d87294edbd86ed662ba2f2f89277"
  license "BSD-2-Clause-Patent"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fd67d989436b66303d0ad7cd3a21bcfed79e54f3aeefd4663285edd45128bb67"
    sha256 cellar: :any,                 arm64_big_sur:  "e1d46041b38687c5d5c93c13652a0866507bd7431768bf69cd9f07ba1d0eb366"
    sha256 cellar: :any,                 monterey:       "5394cbc0b4ce2506b3c679b4d4fcb066225c305a134f2365735b31cec5738c3e"
    sha256 cellar: :any,                 big_sur:        "3bcbc07f5f583829f2a176e88d6bf4ce8a0b5c48642777ac81c1e3f25d9c2573"
    sha256 cellar: :any,                 catalina:       "2fca144593cb7b3eb9236efbc9db26f72ff4d42d1046715fbedbd7f7891a67e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c2cb0d92f2476341e6db584d56b4f3f62ef7b5a628cd273aea438bc45266e19"
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
    pkgshare.install "model"
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
