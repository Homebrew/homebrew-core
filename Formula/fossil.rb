class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/index.html/uv/fossil-src-2.1.tar.gz"
  sha256 "85dcdf10d0f1be41eef53839c6faaa73d2498a9a140a89327cfb092f23cfef05"

  head "https://www.fossil-scm.org/", :using => :fossil

  bottle do
    cellar :any
    sha256 "56ae1118802e74ce91799892dec65a1daaada5a502ec4ba21a123990edbbdba7" => :sierra
    sha256 "7c6b4671963a9678703ba2a3d9eb8ce67ff3f4560a602c1c78aa6391883bc5d0" => :el_capitan
    sha256 "8b465f195fe15819ace885950eda7f6aae1a1b253524479180f1218be154c2c1" => :yosemite
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
