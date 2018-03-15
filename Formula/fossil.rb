class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/index.html/uv/fossil-src-2.5.tar.gz"
  sha256 "f9b07360811f432dfb36ebfb44c83886872556ecce1c80387629ce90e1e4aad3"

  head "https://www.fossil-scm.org/", :using => :fossil

  bottle do
    cellar :any
    sha256 "ae7668a24eb90519dd006aab8b58f90c2ec6c74c288b842a0a4a58792bd4ef14" => :high_sierra
    sha256 "202def77982dcc29a4e47dd6d6184ed42f34fceda71810bfc1cb3b44ce20e113" => :sierra
    sha256 "8f231707dd22e094a41cd14fee7269c87126fe314e8d9b4a203f21eb1fd93198" => :el_capitan
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
