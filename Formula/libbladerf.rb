class Libbladerf < Formula
  desc "USB 3.0 Superspeed Software Defined Radio Source"
  homepage "https://nuand.com/"
  url "https://github.com/Nuand/bladeRF.git",
      tag:      "2023.02",
      revision: "82c5bfd68d1937542a508f031d536fdccabb3985"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://github.com/Nuand/bladeRF.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5fbb4503580629e54eae296f81612551c41b3bb1a50a4a2a5e8d00c36a6e4b54"
    sha256 cellar: :any,                 arm64_monterey: "14d043b8b8863878495b40a1e82db268b1994a24ee7423cc83c1033ce8cb80d6"
    sha256 cellar: :any,                 arm64_big_sur:  "9693eb9b5f637b8e0bfa40aea823c54d58b285765a3a9c5da4abcc1dda9a0acd"
    sha256 cellar: :any,                 ventura:        "bb371787cc0f6d369f90453c08b63841c5deb81cef964b16f9f006429d228e4c"
    sha256 cellar: :any,                 monterey:       "6704f6f10c229d5c4e68f0fbb480ab4eab868d99f0a3d72e995a9ee81a6e2869"
    sha256 cellar: :any,                 big_sur:        "fc4bf5f94b90d788d4ba1f3367884e6e0ab3db1bf2f2170a5e4c41edc23d842d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06bcbbdffb9e59e408049a751051ca29162b941778445e198f7376a26730780f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    ENV.prepend "CFLAGS", "-I#{MacOS.sdk_path}/usr/include/malloc" if OS.mac?
    system "cmake", "-S", "host", "-B", "build", *std_cmake_args, "-DUDEV_RULES_PATH=#{lib}/udev/rules.d"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"bladeRF-cli", "--version"
  end
end
