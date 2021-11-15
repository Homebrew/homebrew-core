class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/home/"
  url "https://fossil-scm.org/home/tarball/version-2.17/fossil-src-2.17.tar.gz"
  sha256 "5c7f1c73f7b5e2af24e10e40f0e07391909c1230b9e284a9d548059e7f377dbf"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/home/uv/download.js"
    regex(/"title":\s*?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0d253775540cedf23dfb2d3135f7a147be6aafcef658ae9567eec0f702254fe4"
    sha256 cellar: :any,                 arm64_big_sur:  "465292116e1bb204aefa96b56c1350c08af43c2963975ef7a06a71f278637858"
    sha256 cellar: :any,                 monterey:       "22187e1f35814920ea0df4139f2c5f0e60a5b249f7f186345b1791a9a8b5af64"
    sha256 cellar: :any,                 big_sur:        "e4ab11e3b0739b51fa4ce5ef8b020df84704c2050a52b1a89a804008ad9fb9d8"
    sha256 cellar: :any,                 catalina:       "c2464646ca8502f36e67f1a0730d93192e6ddf0eb1b113690c1a64689f4a8d4e"
    sha256 cellar: :any,                 mojave:         "a0b10c2b031c7c54b51bf919fcd1d79c0f7047804851192af34b4d2c1e377bc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8b5b3ad3e442b166240b72299c66eb22b989d47b5e06ca96a13e2527be1dc48"
  end

  depends_on "openssl@1.1"
  uses_from_macos "zlib"

  def install
    args = [
      # fix a build issue, recommended by upstream on the mailing-list:
      # https://permalink.gmane.org/gmane.comp.version-control.fossil-scm.user/22444
      "--with-tcl-private-stubs=1",
      "--json",
      "--disable-fusefs",
    ]

    args << if MacOS.sdk_path_if_needed
      "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    else
      "--with-tcl-stubs"
    end

    system "./configure", *args
    system "make"
    bin.install "fossil"
  end

  test do
    system "#{bin}/fossil", "init", "test"
  end
end
