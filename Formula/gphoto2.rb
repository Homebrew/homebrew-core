class Gphoto2 < Formula
  desc "Command-line interface to libgphoto2"
  homepage "http://www.gphoto.org/"
  url "https://downloads.sourceforge.net/project/gphoto/gphoto/2.5.28/gphoto2-2.5.28.tar.bz2"
  sha256 "2a648dcdf12da19e208255df4ebed3e7d2a02f905be4165f2443c984cf887375"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/gphoto2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "dfa88233cd6f19fa4317407ee9fd9bec7ba29524f66cb326541f7c685b02cb93"
    sha256 arm64_big_sur:  "c047e8979df7d2de5fa711166560211822e4b9a52a40de6c8ba8a45aacbe9411"
    sha256 monterey:       "fc8138f5c4bda70622bac1ecc35ec7871559cec84e3a301f3013b9c251367375"
    sha256 big_sur:        "64019eb4a79953685898a72cdd9fd14c2b0f601cb8afdb34be027db10eca3ef2"
    sha256 catalina:       "876e98081384c688eaab6338ff473370915a5c972703c4f72724e4c86d480ca6"
    sha256 x86_64_linux:   "0a95b46e7d23af104359817145b5e660483440048ea7aa94e251d92e6dc3fc86"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libexif"
  depends_on "libgphoto2"
  depends_on "popt"
  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gphoto2 -v")
  end
end
