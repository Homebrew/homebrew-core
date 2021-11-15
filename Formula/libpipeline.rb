class Libpipeline < Formula
  desc "C library for manipulating pipelines of subprocesses"
  homepage "https://libpipeline.nongnu.org/"
  url "https://download.savannah.nongnu.org/releases/libpipeline/libpipeline-1.5.4.tar.gz"
  sha256 "db785bddba0a37ef14b4ef82ae2d18b8824e6983dfb9910319385e28df3f1a9c"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.savannah.nongnu.org/releases/libpipeline/"
    regex(/href=.*?libpipeline[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6c0e638760186cc65964b13cbef1c02cb62bd445ddcbaafb5968122e08e2cc92"
    sha256 cellar: :any,                 arm64_big_sur:  "88b581ef72ef218c98d11fd16fefc6988a4e26338726384c9848be3c5ab33700"
    sha256 cellar: :any,                 monterey:       "32582c61e92be4a8327cd38a2f5dcde4b69b43c2a4900754f8d1e4ab0fa880b0"
    sha256 cellar: :any,                 big_sur:        "0ae6625daee8bfc66e83c6d0176ebd45cc4cc10d682313e6dd4c6f8016f773ff"
    sha256 cellar: :any,                 catalina:       "a2ab80d839a14d5568de6bd78c2e8ccc16efb2d78ad0dafd6c684a850d430d09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88464e66b9f58c437fbca14cdb88850cd4a2bf533a165060565c4696cf4f5ac4"
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
