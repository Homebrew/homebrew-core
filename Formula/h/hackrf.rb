class Hackrf < Formula
  desc "Low cost software radio platform"
  homepage "https://github.com/greatscottgadgets/hackrf"
  url "https://github.com/greatscottgadgets/hackrf/releases/download/v2026.01.3/hackrf-2026.01.3.tar.xz"
  sha256 "d2b76a1115d9b4df648c29efb2f3c8e80009b7cf9a8adf37abbfdba72101b086"
  license "GPL-2.0-or-later"
  head "https://github.com/greatscottgadgets/hackrf.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d76b5c4bfbd77bee1f5e1f48481773c5128ffccb9188bd218801e6f9b3d6d30c"
    sha256 cellar: :any,                 arm64_sequoia: "c3d36821448dcbf52035462d67fcf6ad31049039cb1e6e5a9c4852b887f46382"
    sha256 cellar: :any,                 arm64_sonoma:  "5fc5f1972720b14717a98c0b7212656e47060b984e210c070a50eb2680cf63af"
    sha256 cellar: :any,                 sonoma:        "4b65b90b39360e44ae20f9f143c1f0fe9bc6e74b27dde87c4b4b756695c4737a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "713262f12d04f9c9e42392c6082c74f6599c29de3a1e91a548fdf6fcccdc6e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a9e96a3ec6c4042cabd4823c6b40d1bf1d37ad7e69573eb67733188188f55ed"
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
