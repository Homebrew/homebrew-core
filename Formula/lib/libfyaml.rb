class Libfyaml < Formula
  desc "Fully feature complete YAML parser and emitter"
  homepage "https://github.com/pantoniou/libfyaml"
  url "https://github.com/pantoniou/libfyaml/releases/download/v0.9.3/libfyaml-0.9.3.tar.gz"
  sha256 "d4541c36ae726f51e9df22dd8ac1a19d122666060daf3806e37b848d4c73a8ed"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4c1c1ab8e0f5572427244b924002b54449706b1047ec752c255fb7b0909a4126"
    sha256 cellar: :any,                 arm64_sequoia: "ca9cbce826779d6fc10cbe085eb5120583f39e78230c573789f6e6fafc9e798b"
    sha256 cellar: :any,                 arm64_sonoma:  "8cd8ddda0c6e921e174064fcfcde3a500f9b52a0d8dbe28161d216b27080e1d7"
    sha256 cellar: :any,                 sonoma:        "f61135a902bfdd9d0bfc85b122e980553564f4cc125607fbde02e003b75a8a16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d99d0e24c030a2461a4448569cc10c0328f2202422ce141866bead6cd500597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b579d6e46da5731229cf7a4e12b6d7a773778fa6d2b8ba7dfbc19658b9f66bcd"
  end

  uses_from_macos "m4" => :build

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lfyaml", "-o", "test"
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_equal version.to_s, shell_output("#{testpath}/test").strip
    assert_equal version.to_s, shell_output("#{bin}/fy-tool --version").strip
  end
end
