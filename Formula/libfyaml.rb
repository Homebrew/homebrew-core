class Libfyaml < Formula
  desc "Fully feature complete YAML parser and emitter"
  homepage "https://github.com/pantoniou/libfyaml"
  url "https://github.com/pantoniou/libfyaml/releases/download/v0.8/libfyaml-0.8.tar.gz"
  sha256 "dc4d4348eedca68e8e2394556d57f71410e7d61791a71cbe178302ebe5f26b99"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "fa7e81a89971ca3a452b831bfa017778b24f734b49b57ea730dda4b6791e2cb2"
    sha256 cellar: :any, arm64_monterey: "40163086b94a5d8e80da16ca8bdafe7d36a751aa5cf29a341b0e48d4dc4ff1ea"
    sha256 cellar: :any, arm64_big_sur:  "dd5c5d612403756d6385e35682010025e859a40cc4ed470589847516de520404"
    sha256 cellar: :any, ventura:        "03600f95a70968eb1769442bad770abe8a872c4d0ed0d175cb19cc2f359acbfb"
    sha256 cellar: :any, monterey:       "2abbe7b8e83aa2f820ef0096f8bf2eedccb134f732dd7c819c64406a81a78883"
    sha256 cellar: :any, big_sur:        "e64216b07a8bcc58d1fd8186721901a91feb5b7d67389220f479cb5ea2ae2fab"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #ifdef HAVE_CONFIG_H
      #include "config.h"
      #endif

      #include <iostream>
      #include <libfyaml.h>

      int main(int argc, char *argv[])
      {
        std::cout << fy_library_version() << std::endl;
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lfyaml", "-o", "test"
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_equal version.to_s, shell_output("#{testpath}/test").strip
    assert_equal version.to_s, shell_output("fy-tool --version").strip
  end
end
