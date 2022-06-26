class Libbladerf < Formula
  desc "USB 3.0 Superspeed Software Defined Radio Source"
  homepage "https://nuand.com/"
  url "https://github.com/Nuand/bladeRF.git",
      tag:      "2021.10",
      revision: "d1c382779f00c30bac90ca4f993d5d74f899b937"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://github.com/Nuand/bladeRF.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "368b3aaeda04aac12ddaa62456cc030416e35e7c215d73cf6d1cebcb125666ab"
    sha256 cellar: :any,                 arm64_big_sur:  "3bd059da43b49d6529314c8bd254ca1d5e941de3fbbebbdfa4efe2dfc8fa93f5"
    sha256 cellar: :any,                 monterey:       "7c666147d26ad90b7eb3f95ecbe81267a4c4635632967c689e98caa67e385c88"
    sha256 cellar: :any,                 big_sur:        "e563c2e379a6f2de5af7050e7f15ce925f37e1c13b09dcf7e334f9622b71305b"
    sha256 cellar: :any,                 catalina:       "853f4bbe7e420e746ddcf2ace1f6f5378d9deb77ca3c76ab9ee64e9025c737df"
    sha256 cellar: :any,                 mojave:         "c6820ffe7f3179c0ef363ff2c88b59001524e26899481a7edbb67e60e9ee32c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12f724f52867128957243a6b694502da1a91a6f41bf1c059dfb576585a932297"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    ENV.prepend "CFLAGS", "-I#{MacOS.sdk_path}/usr/include/malloc" if OS.mac?
    mkdir "host/build" do
      system "cmake", "..", *std_cmake_args, "-DUDEV_RULES_PATH=#{lib}/udev/rules.d"
      system "make", "install"
    end
  end

  test do
    system bin/"bladeRF-cli", "--version"
  end
end
