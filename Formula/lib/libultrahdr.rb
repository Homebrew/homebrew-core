class Libultrahdr < Formula
  desc "Reference codec for the Ultra HDR format"
  homepage "https://developer.android.com/media/platform/hdr-image-format"
  url "https://github.com/google/libultrahdr/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "e7e1252e2c44d8ed6b99ee0f67a3caf2d8a61c43834b13b1c3cd485574c03ab9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4fb20ac81780814aa810c0009477f2a2c5a72a3a4be8a085cd62745c1fe87fad"
    sha256 cellar: :any,                 arm64_sequoia: "ea42ab96abe5c0222dc6699bc23f7258be3c8063a3091f49f6995ae46ad3bad8"
    sha256 cellar: :any,                 arm64_sonoma:  "b73d5876637e5adce9edaffdb21d41aaee2af45027246e034a5387364025a796"
    sha256 cellar: :any,                 arm64_ventura: "09d834c256bf1b6cf18ed1031d4ca817c91bb32bbbcb14efa4bc94ddfd76da56"
    sha256 cellar: :any,                 sonoma:        "bcc9eb419fbd3537629dad795cf7aebfa4003054f1ed048938fd921a5dbcf7d6"
    sha256 cellar: :any,                 ventura:       "3b8c26a6c5454bbf9e92f44ffd08e0827e233a2557ca72c3c5fd6165da3897c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57a6cfa364eee5cc9c731bab793e26cecfb58828519daefacdc50e3a4602379a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90793c83c2f180f134f70c76e8e7bb3a72dd1d5959bff6f0add687f792b544ac"
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
    (testpath/"test.cpp").write <<~CPP
      #include <ultrahdr_api.h>
      #include <iostream>

      int main() {
        std::cout << "UltraHDR Library Version: " << UHDR_LIB_VERSION_STR << std::endl;

        uhdr_codec_private_t* encoder = uhdr_create_encoder();
        uhdr_release_encoder(encoder);

        return 0;
      }
    CPP

    pkg_config_cflags = shell_output("pkg-config --cflags --libs libuhdr").chomp.split
    system ENV.cxx, "test.cpp", "-o", "test", "-o", "test", *pkg_config_cflags
    assert_match "UltraHDR Library Version: #{version}", shell_output("./test")
  end
end
