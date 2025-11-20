class Libnsgif < Formula
  desc "Decoding library for the GIF image file format"
  homepage "https://www.netsurf-browser.org/projects/libnsgif/"
  url "https://download.netsurf-browser.org/libs/releases/libnsgif-1.0.0-src.tar.gz"
  sha256 "6014c842f61454d2f5a0f8243d7a8d7bde9b7da3ccfdca2d346c7c0b2c4c061b"
  license "MIT"
  head "git://git.netsurf-browser.org/libnsgif.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?libnsgif[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "24a59de1bad99d2d805e0054f54b09fdadd75c69f50aa3d105d34aaeee184d21"
    sha256 cellar: :any,                 arm64_sequoia:  "1b496d526be94479c22a33a721be3f7c5afe6ec2c0c62d2a9be03b04cce5cb19"
    sha256 cellar: :any,                 arm64_sonoma:   "fb3bd5d0ed63cb47edc86bded832614216985a5f020d4d3e9acf28c05a7d0d8b"
    sha256 cellar: :any,                 arm64_ventura:  "4ab139b0fdd222e35bcbfed812dcc51b330b3ba6349177cb5032b48c5b4d7af8"
    sha256 cellar: :any,                 arm64_monterey: "8c885328683eea466ae2ca2006464e4c5b99417f73bd5cec07434509d64c734e"
    sha256 cellar: :any,                 sonoma:         "7cd6863f98da0e27df13a0a97e80a346077c055408386a7a38dbe60ed67a6ec7"
    sha256 cellar: :any,                 ventura:        "09d9fcad4d83227aec32245847c57beb11a30a5cb8f65ff91977c90cec0e8f0a"
    sha256 cellar: :any,                 monterey:       "c9d626fb8d00576af6ab58d5b64c5485d176969bda7160bccc853f636b910211"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e7dc3ff5a7922684bd75589aa24b77305fe31093ad5b14fdfb3f626f9631035e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7daa143db902d9ecc5a9133f4a82a430c6c4bd14bd5de120f879c82a39b1fb91"
  end

  depends_on "netsurf-buildsystem" => :build

  def install
    args = %W[
      NSSHARED=#{Formula["netsurf-buildsystem"].opt_pkgshare}
      PREFIX=#{prefix}
    ]

    system "make", "install", "COMPONENT_TYPE=lib-shared", *args
    system "make", "install", "COMPONENT_TYPE=lib-static", *args

    # Adjust and keep a copy of tests for test block
    inreplace "test/nsgif.c", "\"../include/nsgif.h\"", "<nsgif.h>"
    pkgshare.install "test"
  end

  test do
    args = %W[
      -I#{include}
      -L#{lib}
      -lnsgif
      -o test_nsgif
    ]

    system ENV.cc, pkgshare/"test/nsgif.c", *args
    cd pkgshare do
      output = shell_output("test/runtest.sh #{testpath}")
      assert_match "Fail:0 Error:0", output
    end
  end
end
