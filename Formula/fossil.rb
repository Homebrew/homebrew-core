class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/download/fossil-src-1.35.tar.gz"
  sha256 "c1f92f925a87c9872cb40d166f56ba08b90edbab01a8546ff37025836136ba1d"

  head "https://www.fossil-scm.org/", :using => :fossil

  bottle do
    cellar :any
    sha256 "2040cf4c0d0fe1f671ce869c08597f856e475701111524e131c876d4f6f09a3d" => :sierra
    sha256 "4ff3c58d50dea6f0324d48f821f1e3371f94e14cb8d0d6e4b0dfbaab0f07db69" => :el_capitan
    sha256 "42495830280a61b3122388aefb108a9c20547c5cd0745f47020999d73bcc03aa" => :yosemite
    sha256 "f0967b37baa7fc8ad43f20a12c61dbbbaf78b2f711acd004180e5d0374617b5d" => :mavericks
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
      args << "--with-tcl"
    else
      args << "--with-tcl-stubs"
    end

    if build.with? "osxfuse"
      ENV.prepend "CFLAGS", "-I#{HOMEBREW_PREFIX}/include/osxfuse"
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
