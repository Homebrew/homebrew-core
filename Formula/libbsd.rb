class Libbsd < Formula
  desc "Utility functions from BSD systems"
  homepage "https://libbsd.freedesktop.org/"
  url "https://libbsd.freedesktop.org/releases/libbsd-0.8.3.tar.xz"
  sha256 "934b634f4dfd865b6482650b8f522c70ae65c463529de8be907b53c89c3a34a8"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    sha256 "0efc964be0372ef6082dce1b54a2ab515b7a2a62279a177c476d925da023c0d1" => :x86_64_linux
  end

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "strtonum", shell_output("nm #{lib/"libbsd.so"}")
  end
end
