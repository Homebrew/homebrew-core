class Libpipeline < Formula
  desc "C library for manipulating pipelines of subprocesses"
  homepage "https://libpipeline.nongnu.org/"
  url "https://download.savannah.nongnu.org/releases/libpipeline/libpipeline-1.5.6.tar.gz"
  sha256 "60fbb9e7dc398528e5f3a776af57bb28ca3fe5d9f0cd8a961ac6cebfe6e9b797"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.savannah.nongnu.org/releases/libpipeline/"
    regex(/href=.*?libpipeline[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0c7e76c20cff63cb6bf424ab9ed15761c10d2c873ccaa879605b87a68924706c"
    sha256 cellar: :any,                 arm64_big_sur:  "1baa2e3a2cbc33184b3bf60f51f66bef818c51922bc97f836d2a442c719497ac"
    sha256 cellar: :any,                 monterey:       "0ea83c70eea28ad8ce5db21311d6a6f7ec63c129d06b04b97f19b2cb84497cac"
    sha256 cellar: :any,                 big_sur:        "23561a9dd187280f6b2fc7e1d1ef6fcae4d9f027ae7606ffb1541c269f7205e8"
    sha256 cellar: :any,                 catalina:       "aef70c833c5b3c1b6c45f54a1a7be505e4edc57cf54f3b4bb2de265cba3c78f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a90fa10efacae46000534e2ffd57a36eae8feeab863f96859a225ab73feff953"
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
