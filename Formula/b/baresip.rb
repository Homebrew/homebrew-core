class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v3.10.1.tar.gz"
  sha256 "892f8c9918f887c8923c9bb939d251766f9e30cb436ff10db338871a66d81d10"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sonoma:   "1069b784ec3429ad8f381593ce728f53697f136c3cb894e09d5626bf73608ff0"
    sha256 arm64_ventura:  "8b137dc00a0a593a2357985330d3e416d443be8683a238c4b40f87575ecdc747"
    sha256 arm64_monterey: "ed807adf1b8154eaeeebdc6e6c4dcc57a4241028905a423ef11069cb870d5874"
    sha256 sonoma:         "07cefd05016aec66dc39d01b9ff41c45c15537fbf3f7b5a70cc9b473507b9b1b"
    sha256 ventura:        "c70fc9410ae69cd6e843625574cd69632e74309f4a28d68f4e70c064200490da"
    sha256 monterey:       "1188a456ac869ecbfc74a39499547482d2a4d477a16246933c9c380435fbf296"
    sha256 x86_64_linux:   "064df52268052e70e6f4253c094444b481febbb9e2121407d991731969c32349"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    libre = Formula["libre"]
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{libre.opt_include}/re
    ]
    system "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "-j"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
