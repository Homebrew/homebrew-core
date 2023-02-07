class Libfyaml < Formula
  desc "Fully feature complete YAML parser and emitter"
  homepage "https://github.com/pantoniou/libfyaml"
  url "https://github.com/pantoniou/libfyaml/releases/download/v0.8/libfyaml-0.8.tar.gz"
  sha256 "dc4d4348eedca68e8e2394556d57f71410e7d61791a71cbe178302ebe5f26b99"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "a583bb53a056d7d0ab13c6190b0841dde737af144a237638f911ad9ea34f4dcc"
    sha256 cellar: :any, arm64_monterey: "ff5758db861a5771a65f1393d16f5886bc28c949fd7eec09189c5512c6e0206b"
    sha256 cellar: :any, arm64_big_sur:  "3f5766a648ce4b799d10fae549c1822a7442b3774deba39020a13cd3a468da00"
    sha256 cellar: :any, ventura:        "f4034ec13f13902a182d7fbac4be562b6c02255e12fcd5b7907d8b200d478fc9"
    sha256 cellar: :any, monterey:       "e195ed6925ab0acb051f495b341cb93cb4c0d65815a2e3f117be877ffd0cdc07"
    sha256 cellar: :any, big_sur:        "6b9ae604f5107fa9032d8db619e9d8cd9f1c9816686862dc9090e143dc3e544e"
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
