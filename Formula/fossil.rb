class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/index.html/uv/fossil-src-2.5.tar.gz"
  sha256 "f9b07360811f432dfb36ebfb44c83886872556ecce1c80387629ce90e1e4aad3"

  head "https://www.fossil-scm.org/", :using => :fossil

  bottle do
    cellar :any
    sha256 "e03c1769b10b9f8686fe3c83556ad4312370f25a5367bd99eeddf2d2578cb32a" => :high_sierra
    sha256 "41a2bbfb08e60fd6bb03cddf1367abf9404d1fbba34f19d758b160ce2c8b8215" => :sierra
    sha256 "e3dc23ba2409c3382f72232fa895bf6fbca046d39c164018e28b058d304bb843" => :el_capitan
  end

  option "without-json", "Build without 'json' command support"
  option "without-tcl", "Build without the tcl-th1 command bridge"

  depends_on "openssl"
  depends_on :osxfuse => :optional

  def install
    args = [
      # fix a build issue, recommended by upstream on the mailing-list:
      # https://permalink.gmane.org/gmane.comp.version-control.fossil-scm.user/22444
      "--with-tcl-private-stubs=1",
    ]
    args << "--json" if build.with? "json"

    if MacOS::CLT.installed? && build.with?("tcl")
      sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
      args << "--with-tcl=#{sdk}/System/Library/Frameworks/Tcl.framework"
    else
      args << "--with-tcl-stubs"
    end

    if build.with? "osxfuse"
      ENV.prepend "CFLAGS", "-I/usr/local/include/osxfuse"
    else
      args << "--disable-fusefs"
    end

    system "./configure", *args
    system "make"
    bin.install "fossil"
  end

  test do
    system "#{bin}/fossil", "init", "test"
  end
end
