class Hackrf < Formula
  desc "Low cost software radio platform"
  homepage "https://github.com/greatscottgadgets/hackrf"
  url "https://github.com/greatscottgadgets/hackrf/releases/download/v2026.01.1/hackrf-2026.01.1.tar.xz"
  sha256 "283387d7a1aad965b07287adea7361a2a86176e854e2f2b808f58b5626015de4"
  license "GPL-2.0-or-later"
  head "https://github.com/greatscottgadgets/hackrf.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "535ef287b71310d2773d1fc638fe75a9d476baf6051a7588259c4795d1cb16ea"
    sha256 cellar: :any,                 arm64_sequoia: "7e20b7715f2c0e31d69919dd7bd3659b9a2c43dece9bd2ff821a31bf3f1201f3"
    sha256 cellar: :any,                 arm64_sonoma:  "3070fdbed1e1c14913df1373f673c9bd7d5b0ebf4745aabe2e6f42b7228a7064"
    sha256 cellar: :any,                 sonoma:        "2e5bda6987b14a31a6fd5c157ca12946c3fe7644ff6c50b1b5fccf3586de8924"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "759a2d918401f4ec3ef9f82460ed52cf8f2b8253b86e54002ae47cd102d0ff2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9a9b5a32b7fa0891d58482bbdfe6d95872f204c348fa69c2d07aa722a0c90f6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "libusb"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    if OS.linux?
      args += %W[
        -DUDEV_RULES_GROUP=plugdev
        -DUDEV_RULES_PATH=#{lib}/udev/rules.d
      ]
    end

    system "cmake", "-S", "host", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "firmware-bin/"
  end

  test do
    shell_output("#{bin}/hackrf_transfer", 1)
  end
end
