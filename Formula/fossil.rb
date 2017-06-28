class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/index.html/uv/fossil-src-2.2.tar.gz"
  sha256 "9b8f82196eb89e4a2e82b4bcc51e314ae509a22c37073a18a0b325f11c53cf71"

  head "https://www.fossil-scm.org/", :using => :fossil

  bottle do
    cellar :any
    sha256 "12deae19321986607119513bf6f7b0b71b0754a7d12615ea17b89c78d721ff6d" => :sierra
    sha256 "ea864189bd14e2b9ff2b699a4f7f42426449550a22c71bf6de4a5a49c825ea8f" => :el_capitan
    sha256 "e0eb6dd0f08800d8939ba216c5e068f8ba0efddc79b571d5adb9590aabfe45dc" => :yosemite
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
