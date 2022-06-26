class Libpipeline < Formula
  desc "C library for manipulating pipelines of subprocesses"
  homepage "https://libpipeline.gitlab.io/libpipeline/"
  url "https://download.savannah.nongnu.org/releases/libpipeline/libpipeline-1.5.6.tar.gz"
  sha256 "60fbb9e7dc398528e5f3a776af57bb28ca3fe5d9f0cd8a961ac6cebfe6e9b797"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.savannah.nongnu.org/releases/libpipeline/"
    regex(/href=.*?libpipeline[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c6dc99a6537ce4ba4215fa9003b649c23f80a7955afff24f33a480bea6b52510"
    sha256 cellar: :any,                 arm64_big_sur:  "f947a671382f0b419387d3a3ad3762bd171ddf2018dceacdf625c792904e80d6"
    sha256 cellar: :any,                 monterey:       "d078a100cf03fa99475311b2a941d0c1363abac614ca6ab61699740cb4e14dae"
    sha256 cellar: :any,                 big_sur:        "c554abf44cf045dead6cfb12a98101be4f4dc902250402b05e576f30ed7c4bb8"
    sha256 cellar: :any,                 catalina:       "bf7e539e94e8906da42a6aed30eccd1321e797ca3a20da3cdd06f8364d52fca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1897a794fad65cf1e381a71faef2d24212bcec449578d8ab681a5969e987544c"
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
