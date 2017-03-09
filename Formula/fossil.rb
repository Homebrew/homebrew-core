class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/index.html/uv/download/fossil-src-2.0.tar.gz"
  sha256 "359f474844792b57ba2733277c2dc8ba3b20d890925d50618d85a20867ae1761"

  head "https://www.fossil-scm.org/", :using => :fossil

  bottle do
    cellar :any
    sha256 "0cb54fdee7d629a121c9021aab29465b7b37dab0bcebec91d4c8707e06f6b740" => :sierra
    sha256 "d705d293b601e3e20ec4d417252649f938ad7627913b9e2153004d3358742da0" => :el_capitan
    sha256 "4a81061ba52bd477c0825a0e78091a436c4aedc1b9c062093c1fdc9659486e19" => :yosemite
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
