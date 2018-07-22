class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/index.html/uv/fossil-src-2.6.tar.gz"
  sha256 "76a794555918be179850739a90f157de0edb8568ad552b4c40ce186c79ff6ed9"
  head "https://www.fossil-scm.org/", :using => :fossil

  bottle do
    cellar :any
    sha256 "d95826fb9776c9a7da204733217ed5adef89c57e695f30301d02146882b1d3db" => :high_sierra
    sha256 "be422f110ba495e9d61aed8e3b00a858cdf25cff0f70a59c9130334ea5ed87d4" => :sierra
    sha256 "5847c8312bad3981f2c516ddbccf22158875d5debf79c6f8fb2b62e794e462ff" => :el_capitan
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
