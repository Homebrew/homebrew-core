class Libudfread < Formula
  desc "Universal Disk Format reader"
  homepage "https://code.videolan.org/videolan/libudfread"
  url "https://download.videolan.org/videolan/libudfread/libudfread-1.2.0.tar.xz"
  sha256 "bb477cbd4cfbfc7787d9d05b71ee5e70430f5cfebf1297497f7e83547958050f"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libudfread/"
    regex(/href=.*?libudfread[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c30a3d1c34e209bd79301f3626e0e617ed841979ae1e33b0acc066c9643f9dea"
    sha256 cellar: :any,                 arm64_sequoia: "a563689c17ca21d204a228773ec9380b5b0880bd3b0ab322170f8596be7f844a"
    sha256 cellar: :any,                 arm64_sonoma:  "a5818ef3abbd4de631f60ba8abfd0450585c789c57fd5ffa4129a6d2aa446e37"
    sha256 cellar: :any,                 arm64_ventura: "d5f039fc1b4b415f554391bd3500cd47c3f7129baa8729d302f9f31d9bb2c939"
    sha256 cellar: :any,                 sonoma:        "f48224450840a89fd3c0941f0fdfcca6e25900174a2dc0529b5b741794ebdc1a"
    sha256 cellar: :any,                 ventura:       "dcfc7c2ae1e18c03814140a7fe31507166ad7174c105b99d1a6db3afdec9f51c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "977b8b3c0c96cbb74267ddd08cbef36a51ffa97475b350cd95712fcccd759f63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d739ff8b7b3989919e494baae8ae502b249e61afe81587064d675ab7271744f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    (pkgshare/"examples").install "examples/udfcat.c"
  end

  test do
    cp (pkgshare/"examples/udfcat.c"), testpath

    system ENV.cc, "udfcat.c", "-I#{include}/udfread", "-L#{lib}", "-ludfread", "-o", "udfcat"
    assert_match "usage: udfcat <image> <file>", shell_output("./udfcat 2>&1", 255)
  end
end
