class Libpipeline < Formula
  desc "C library for manipulating pipelines of subprocesses"
  homepage "https://libpipeline.gitlab.io/libpipeline/"
  url "https://download.savannah.nongnu.org/releases/libpipeline/libpipeline-1.5.7.tar.gz"
  sha256 "b8b45194989022a79ec1317f64a2a75b1551b2a55bea06f67704cb2a2e4690b0"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.savannah.nongnu.org/releases/libpipeline/"
    regex(/href=.*?libpipeline[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "35abc98e794d1de477dae0c1982a34e6be42caf701cfe4e08c335ac0ec180463"
    sha256 cellar: :any,                 arm64_monterey: "2dff66f60f4e5256cbdc39fce9dafbe19c1a682620455e0e120d1b9d6b6e5bf4"
    sha256 cellar: :any,                 arm64_big_sur:  "2d9eb02b496aa0dbb565bcfca50ccb294c37b9b6f8055bd41e472b4f8cf34b6c"
    sha256 cellar: :any,                 ventura:        "3c8cc5bee3e315a280a8ab7d87078fa46177e44f25987482164354f61e6d243a"
    sha256 cellar: :any,                 monterey:       "646e4743ba1587ccf3c768307121277d6379acdc3582392e0565d92fa7ba7345"
    sha256 cellar: :any,                 big_sur:        "4a8a4755b0c043a39a0ea76ed633c2e4f256428c37f9ba5e6cc798394ee8d24d"
    sha256 cellar: :any,                 catalina:       "a796215ec7260521454da16526254ab307461ae584e074df5a864a6b4257f9fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01849a18b428e505f03acab84ec2051994cb0b62935c350dba41c74a24dcadf8"
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
