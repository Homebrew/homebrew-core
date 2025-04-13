class Libbladerf < Formula
  desc "USB 3.0 Superspeed Software Defined Radio Source"
  homepage "https://nuand.com/"
  url "https://github.com/Nuand/bladeRF.git",
      tag:      "2023.02",
      revision: "41ef63460956e833c9b321252245257ab3946055"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "MIT"]
  revision 1
  head "https://github.com/Nuand/bladeRF.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # and they may retag a stable version before release, so the `GithubLatest`
  # strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "2651db296521b2728bc29c789eeb500044d640a0a9a8483c089412154577701e"
    sha256 cellar: :any,                 arm64_sonoma:   "a1f53b13340f34c10cd6472165c539b94c6b99ccfc2dd0e0b010ae989276223e"
    sha256 cellar: :any,                 arm64_ventura:  "981e3c3b94703b88a9d9f7e341a16ad8ea969fdcc1ce06ce9edf514d8bd9d7e0"
    sha256 cellar: :any,                 arm64_monterey: "c2a39382f86a2a39efc8e8c136f5a2aa9b350b46fda72a395f36800f92bceff6"
    sha256 cellar: :any,                 arm64_big_sur:  "198b025b353d6fc684abacc3b9521cb614e75f262d2f7bc15241a011cc421c1c"
    sha256 cellar: :any,                 sonoma:         "1d3f7838eda5b2ab9c9f1f984ae36241f436261ffe98375e578cb359db1ae366"
    sha256 cellar: :any,                 ventura:        "447589cd895d154bf6ce5b1cf0ed762b03cec1fb237d75b6c16e012257589ba9"
    sha256 cellar: :any,                 monterey:       "a6eb04e265dbc9f484faed50f3d7c779311d23010343e23b3b266d5150092985"
    sha256 cellar: :any,                 big_sur:        "acc0fcce7eceb0ae5fcf57777d4eed7c73bca6583841967cf82593d2c51e3ceb"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b1d15c52df67382a53ec8d17a7a717710d2e5aedfa50b93b7f7701ecac71ac0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "841a063c843f054272069b435c58f3c665c1c1190e489f7e7c34729d3a0662b1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"

  uses_from_macos "libedit"

  def install
    ENV.prepend "CFLAGS", "-I#{MacOS.sdk_path}/usr/include/malloc" if OS.mac?
    system "cmake", "-S", "host", "-B", "build", "-DUDEV_RULES_PATH=#{lib}/udev/rules.d", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"bladeRF-cli", "--version"
  end
end
