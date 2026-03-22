class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "af190d326891c6c51f45af130bca00a4826c7de9f9cbec3c3f4ff90d7393739c"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "7ed2a57d5ae220202dafe49d4b719f654e975969633054ad93f92e892f125a4f"
    sha256 arm64_sequoia: "1956fdac69750bfc0c2645660ada92b7ec789bef6d6c79a9852dac0b173a1a55"
    sha256 arm64_sonoma:  "68fe07ffcab0d5d096499d1a23ae7e6b3cdeb31751f43a340dc943701050246c"
    sha256 sonoma:        "48e5b25337757869b3e7e193079d1a9576664475d3814024da6a5c33f74b4b5f"
    sha256 arm64_linux:   "3a4dd485ef3608c2bd96a0734c5ee9b2bda1bc892198d843d6fe44ea32c1b110"
    sha256 x86_64_linux:  "31f13b9ffde3dfa6925185f86f5d10494a022ff89d7c11239c5683cd03190a69"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{Formula["libre"].opt_include}/re
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
