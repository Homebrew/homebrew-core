class Libultrahdr < Formula
  desc "Reference codec for the Ultra HDR format"
  homepage "https://developer.android.com/media/platform/hdr-image-format"
  url "https://github.com/google/libultrahdr/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "aa8d193bb887c348c419780511dd03b374f4e07af8812b6d3f80c8537cf1ef2c"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ccb549500bbd4364a05dbc633373a868a1a65ace52bc68eaae1904bfb535e4b9"
    sha256 cellar: :any, arm64_sequoia: "9e886c093543e23553793ec438724a4dfb9907defe282b439fefab0a30d6b083"
    sha256 cellar: :any, arm64_sonoma:  "573d750d9e3424ebb9144956ab81eca7ce40a2360ab03dc462da5c32d167441e"
    sha256 cellar: :any, sonoma:        "d780f5e1dccfce733f863edf35f9e76961545b62f4ffe97b6ff3b3d78d9659aa"
    sha256 cellar: :any, arm64_linux:   "ff98c2f4315c8a96bd6e49916de792e61348257d7aab7afbe6df34bce00b035a"
    sha256 cellar: :any, x86_64_linux:  "04cdfb5e833f747d8e485eee4f76b6c275138115ac12b0e2736504d7df2423c1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "jpeg-turbo"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("pkg-config --modversion libuhdr")

    (testpath/"test.cpp").write <<~CPP
      #include <ultrahdr_api.h>
      #include <iostream>

      int main() {
        uhdr_codec_private_t* encoder = uhdr_create_encoder();
        if (encoder == nullptr) return 1;
        uhdr_release_encoder(encoder);

        std::cout << "encoder ok" << std::endl;
        return 0;
      }
    CPP

    pkg_config_cflags = shell_output("pkg-config --cflags --libs libuhdr").chomp.split
    system ENV.cxx, "test.cpp", "-o", "test", *pkg_config_cflags
    assert_match "encoder ok", shell_output("./test")
  end
end
