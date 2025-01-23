class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v3.19.0.tar.gz"
  sha256 "798dd6730e334cfb4fcda4293f2dab9828129ff1d83eb8fe92df8214aa8c36e9"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sequoia: "e4d892397a4399b413de474fd2b2711a816784e5647122b83524f56fb18eda7c"
    sha256 arm64_sonoma:  "b153302292ab73aba4aa42f052f4dcae03b27b148570e6bcbe12d669b2ea8b1e"
    sha256 arm64_ventura: "8d3430aaf06f590828f6ad2ce18557331de34e20c2dc2b1b1070796ba94ed7d5"
    sha256 sonoma:        "60258a7d03e3c38af2f1219be109b2d174e69849805398b33915bfdaccd0dd37"
    sha256 ventura:       "9434bd3b917860055a44f400ee3ac12ee54e99871c7e5bc9a0d960aec79c41ea"
    sha256 x86_64_linux:  "2cf2f60134a3cebeb9816f2e50023ceac1007bd98112004b957f27aa7504759c"
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
