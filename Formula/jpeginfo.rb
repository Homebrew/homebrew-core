class Jpeginfo < Formula
  desc "Prints information and tests integrity of JPEG/JFIF files"
  homepage "https://www.kokkonen.net/tjko/projects.html"
  url "https://www.kokkonen.net/tjko/src/jpeginfo-1.6.1.tar.gz"
  sha256 "629e31cf1da0fa1efe4a7cc54c67123a68f5024f3d8e864a30457aeaed1d7653"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/tjko/jpeginfo.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?jpeginfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d8796793101b1209893adad2d84673d19b840b492efb536858bfcccf763cfe2b"
    sha256 cellar: :any,                 arm64_big_sur:  "50c206aa6db9a585dce9d98f62a284ed6307db0f1d23ad2c33dcc0304c758851"
    sha256 cellar: :any,                 monterey:       "fbf71ea02631455b9a9040a524fbc54eb26aac6e8e043f61615943aa4b806f57"
    sha256 cellar: :any,                 big_sur:        "56c093051a76d9043c962b2f162f77378c88642960fdb3cb6187d964dc21fae4"
    sha256 cellar: :any,                 catalina:       "24ac88483867b7e21f8f3af9251598a4176fbf2775f43632be89a8eb9b8356c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13ebc4e227aa01bb44b87b33e40347a23e687f2cda3554fc1c773a6d52e37336"
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
