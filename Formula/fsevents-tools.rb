class FseventsTools < Formula
  desc "Command-line utilities for the FSEvents API"
  homepage "http://geoff.greer.fm/fsevents/"
  url "http://geoff.greer.fm/fsevents/releases/fsevents-tools-1.0.0.tar.gz"
  sha256 "498528e1794fa2b0cf920bd96abaf7ced15df31c104d1a3650e06fa3f95ec628"

  bottle do
    cellar :any_skip_relocation
    sha256 "8190bdd8d9d88f9ee6ebdc56434551a44a39502225160ad2604562d9c7ed0822" => :sierra
    sha256 "a15d1b927a74d8b76b553d696343ac5fe82396f8b5b052e15adc6c3270f2ccd6" => :el_capitan
    sha256 "9d4bda3175c503f8ff65f134495de43471854eacc3396a9cf1895d5c2b91cb63" => :yosemite
    sha256 "045442f0279c20196e0941fbf160557ebdea04169267ba8105717d7d207cc346" => :mavericks
  end

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
