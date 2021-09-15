class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "https://download.osgeo.org/geos/geos-3.9.1.tar.bz2"
  sha256 "7e630507dcac9dc07565d249a26f06a15c9f5b0c52dd29129a0e3d381d7e382a"
  license "LGPL-2.1"

  livecheck do
    url "https://download.osgeo.org/geos/"
    regex(/href=.*?geos[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "55162eaa549fb0b551ddbd6fa2e7e25da1f9c4cf9772ed62d077f0f8bf03ecbe"
    sha256 cellar: :any,                 big_sur:       "763727a2a096dd9a5ba2735672f2ff2ee58c7c1efd8b2db8d79dc2e5e6989cbe"
    sha256 cellar: :any,                 catalina:      "6ebbc7afe80b38660e33be4b95a47654d0d4dc067b13076f1b88d06c52dd717a"
    sha256 cellar: :any,                 mojave:        "ff5f29ff0856fdc987c5338a066ddbaa2eb3e231ff1a87bc7c166be73dcac892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88c1238afa2af41abed21be1069ce32fb5732d3b64317cb96087bdf4c23cbf15"
  end

  depends_on "swig" => :build
  depends_on "python@3.9"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-python
      PYTHON=#{Formula["python@3.9"].opt_bin}/python3
    ]
    args << "--disable-inline" if Hardware::CPU.arm?

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/geos-config", "--libs"
  end
end
