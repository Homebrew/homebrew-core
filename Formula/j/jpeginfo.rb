class Jpeginfo < Formula
  desc "Prints information and tests integrity of JPEG/JFIF files"
  homepage "https://www.kokkonen.net/tjko/projects.html"
  url "https://www.kokkonen.net/tjko/src/jpeginfo-1.7.0.tar.gz"
  sha256 "dc985083448d9707d42e49bed826a247c0dbda6913c870e9a5d9bf7c74939659"
  license "GPL-3.0-or-later"
  head "https://github.com/tjko/jpeginfo.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?jpeginfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "23539379e02e45c0d9f11370bea9cd29f4eb86c3a5178680150b315039b95dad"
    sha256 cellar: :any,                 arm64_ventura:  "7b2d0e338d66f520f18491d3044a22de5d3844f6d5bfce18cea0510c31e77554"
    sha256 cellar: :any,                 arm64_monterey: "82ac2b4fe44b18dae1dfb51814ade86bcf4015365665bc07120306be468332e8"
    sha256 cellar: :any,                 arm64_big_sur:  "d2934f7604dc04fc17813a1d3a6d1b10b400b648009ffa65f26045c6ffb136cf"
    sha256 cellar: :any,                 sonoma:         "807da76d7218bb4d163d7284cc81951ed87614ca427f466cc77ed4d13830ecc8"
    sha256 cellar: :any,                 ventura:        "dd1b225d43bf11f5da7dd72437a1a49900b2f0c251b14885cf8417198a1e3455"
    sha256 cellar: :any,                 monterey:       "8cbf7240dbba078ad4a7345dc5f331b2287d166816052004e724a278492d4b74"
    sha256 cellar: :any,                 big_sur:        "0f1295e1dcccbfbb1fc3c63033b128050047a6541024b5cfe7d10da0164bf153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c950c04a37faad38e1ef55191eaa29a6670c1eec3c4ce3c7959b3cf4313cfcd"
  end

  depends_on "autoconf" => :build
  depends_on "jpeg-turbo"

  def install
    ENV.deparallelize

    # The ./configure file inside the tarball is too old to work with Xcode 12, regenerate:
    system "autoconf", "--force"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/jpeginfo", "--help"
  end
end
