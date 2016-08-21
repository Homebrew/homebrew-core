class FseventsTools < Formula
  desc "Command-line utilities for the FSEvents API"
  homepage "http://geoff.greer.fm/fsevents/"
  url "http://geoff.greer.fm/fsevents/releases/fsevents-tools-1.0.0.tar.gz"
  sha256 "498528e1794fa2b0cf920bd96abaf7ced15df31c104d1a3650e06fa3f95ec628"

  head do
    url "https://github.com/ggreer/fsevents-tools.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "pkg-config" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    fork do
      sleep 2
      touch "testfile"
    end
    assert_match "notifying", shell_output("#{bin}/notifywait testfile")
  end
end
