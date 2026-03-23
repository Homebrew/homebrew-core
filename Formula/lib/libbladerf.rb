class Libbladerf < Formula
  desc "USB 3.0 Superspeed Software Defined Radio Source"
  homepage "https://nuand.com/"
  url "https://github.com/Nuand/bladeRF.git",
      tag:      "2025.10",
      revision: "fcf9423325ae49f5fdd2e5b52ab68bfc2576ad47"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://github.com/Nuand/bladeRF.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # and they may retag a stable version before release, so the `GithubLatest`
  # strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "febcfae38d459de288b75923c21e2364c439f2eb550c8bebd881bdaa4d1ef74b"
    sha256 cellar: :any,                 arm64_sequoia: "60b5f9a58a606f815208847c0b8da31a7bdc534a36ec2b781d3e2f51c31f2175"
    sha256 cellar: :any,                 arm64_sonoma:  "6ec6e4e9862732551e4d0471af522ab851d67ff45d2040093f1cd222c559ed64"
    sha256 cellar: :any,                 sonoma:        "5142e90fbc653861b14ab374bfb6fffefbc1dbe832b0531efb5ab9cafa36cecb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f14a8ae992f6d8ab74495ba8065a94d0e88eddaa20a2aedbb30e4c57afa5c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eacf634e18793576da2d977db15e0e433beeff5bdf492489008a03eae22e990"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"
  depends_on "ncurses"

  uses_from_macos "curl"
  uses_from_macos "libedit"

  def install
    ENV.prepend "CFLAGS", "-I#{MacOS.sdk_path}/usr/include/malloc" if OS.mac?
    args = %W[
      -DUDEV_RULES_PATH=#{lib}/udev/rules.d
    ]
    system "cmake", "-S", "host", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"bladeRF-cli", "--version"
  end
end
