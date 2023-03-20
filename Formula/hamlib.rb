class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.5.4/hamlib-4.5.4.tar.gz"
  sha256 "b1aea97d6093990b77d5dc4bde6b9ca06183ddb7e24da7e2367a2acc957b7ac2"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "48137fb078cc2994604e618106f03cc7d09ac56398b9f9d53c9694865397965a"
    sha256 cellar: :any,                 arm64_monterey: "158e850c7eaf088143bf286c2b08c1fb121d7d7a3d527136969e190405e1ce8c"
    sha256 cellar: :any,                 arm64_big_sur:  "93abdf67b50067068d0b0b410f1e9b4467e698170213f55c4234d590738074ec"
    sha256 cellar: :any,                 ventura:        "dc62a50949768509778b9cd56bc34222e60b9dad7cfc19929a3cb96ef4533f7e"
    sha256 cellar: :any,                 monterey:       "6e3fe02346bbfc46d5a73848b37429cd1fd05d85e9b542e65dd8695426b2a78e"
    sha256 cellar: :any,                 big_sur:        "37874d219c2667e2aa5e93bbc64c8a6ce7a3b051d01a202c2238fbb43a13feb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "381273a520366df61231cbac384fc3d8d7607c0fbc43b8cf624d823d92cbd2bc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "libusb-compat"

  fails_with gcc: "5"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rigctl", "-V"
  end
end
