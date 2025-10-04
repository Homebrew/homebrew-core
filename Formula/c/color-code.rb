class ColorCode < Formula
  desc "Free advanced MasterMind clone"
  homepage "http://colorcode.laebisch.com/"
  url "http://colorcode.laebisch.com/download/ColorCode-0.8.7.tar.gz"
  sha256 "10d6bb0ab532e603c30caf7fafc5541fa1de5c31f2e154ebc6e1bed410de182a"
  license "GPL-3.0-or-later"

  livecheck do
    url "http://colorcode.laebisch.com/download"
    regex(/href=.*?ColorCode[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "ad3f82efc9695c34bf0108765bd03a823567321fb844bbd2dfed5ed7b679ba4d"
    sha256 cellar: :any,                 arm64_sequoia:  "eca15102195ecbf35b9b5db261ad63a1e7849f68048a9872757c99a300af2198"
    sha256 cellar: :any,                 arm64_sonoma:   "5279b770c1208847aa8bc485ffe5d60a457a22867ba8ae3b9b72a6ccb10b9cee"
    sha256 cellar: :any,                 arm64_ventura:  "656617a979b49e4b6cb0ea002e6d2a5d715a042bbbab3d4d4c0524f0b0b93845"
    sha256 cellar: :any,                 arm64_monterey: "c295af784bbc09fa4459c60004d9b525f9e3b5b8796394e1127b20453bf2e724"
    sha256 cellar: :any,                 sonoma:         "7d1b463d79dd8300b303a00ab0f578d1468e43cdce5c7a13b1638cf68f91c49e"
    sha256 cellar: :any,                 ventura:        "b954f75bdcddf2b8e43abe941bd31564c24e9571b08f9cd4e4631a58cee0003c"
    sha256 cellar: :any,                 monterey:       "af2e8d3a61997ad1b25189d2a9b148cbf7fdb34d5f0c92c8c118ba477b68e586"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e8bbc4be9fdd3d92db8ca9620bac00252cd3eee18dce7ebdbdfab5d83d13aa33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd2a46ae5f69b106738617bd41d8fe1d2a71a34dcb876850ac1c698b4ca09496"
  end

  # No means of contact or public tracker page to discuss/view Qt 6 status.
  # Can undeprecate if new release with Qt 6 support is available.
  deprecate! date: "2026-05-19", because: "needs end-of-life Qt 5"

  depends_on "cmake" => :build
  depends_on "qt@5"

  def install
    system "cmake", "-S", "src", "-B", "build_cmake", *std_cmake_args
    system "cmake", "--build", "build_cmake"
    bin.install "build_cmake/colorcode"
  end

  test do
    # We cannot write a more substantial test because executing the binary
    # opens a GUI, which is not supported by Homebrew's test environment
    system bin/"colorcode", "-h"
  end
end
