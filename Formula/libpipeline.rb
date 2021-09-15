class Libpipeline < Formula
  desc "C library for manipulating pipelines of subprocesses"
  homepage "http://libpipeline.nongnu.org/"
  url "https://download.savannah.nongnu.org/releases/libpipeline/libpipeline-1.5.3.tar.gz"
  sha256 "5dbf08faf50fad853754293e57fd4e6c69bb8e486f176596d682c67e02a0adb0"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.savannah.nongnu.org/releases/libpipeline/"
    regex(/href=.*?libpipeline[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0a398cdb65f5321e356e7035a3bc2352dd3b92e2f37632d85a64fbdd0510d41d"
    sha256 cellar: :any,                 big_sur:       "ab0b600e54ba2acd5878ed910af86518a905a1d53fdeca8d5a8abf363d09a584"
    sha256 cellar: :any,                 catalina:      "efa57a53e202d19ae3afb04b55b85e37939a0d0cff1e6af9b40607c9acd8b6d0"
    sha256 cellar: :any,                 mojave:        "337f3a1e0b07e0fcdece44321f28be0668be70fb914e5f37000bd6b42ffa188c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ab630181184892e74dd5af27c02b3ca1370e15cada9a0950b68c85934364cb7"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <pipeline.h>
      int main() {
        pipeline *p = pipeline_new();
        pipeline_command_args(p, "echo", "Hello world", NULL);
        pipeline_command_args(p, "cat", NULL);
        return pipeline_run(p);
      }
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lpipeline", "-o", "test"
    assert_match "Hello world", shell_output("./test")
  end
end
