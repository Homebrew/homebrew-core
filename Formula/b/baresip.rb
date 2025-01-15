class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v3.19.0.tar.gz"
  sha256 "798dd6730e334cfb4fcda4293f2dab9828129ff1d83eb8fe92df8214aa8c36e9"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sequoia: "a85dc12a6af1edafac98d48d8d0c531f859f1e69fab58d2d9bc7efed17640852"
    sha256 arm64_sonoma:  "2b5d336da2b9005ec2f68d1d1b79813f34f5ddb653fa6dfecd1fc4790ecf7384"
    sha256 arm64_ventura: "47a256f4e1e78a6c01895e4b0cae285f0ccb0adf4dbace899fb5e0869916f814"
    sha256 sonoma:        "4e9e52ae5feb752219bc8b4dbb731c215f44853ac12404baa999ff072dc504a0"
    sha256 ventura:       "1b8008fae372ecaa815a98a948dd405ab34a8396721cbb5e86ef6b5523b3df0f"
    sha256 x86_64_linux:  "8ea08bb89abf975bec8c804bfa77675a70f0aacc12f3e3b40e0f67f010a0dd8b"
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
