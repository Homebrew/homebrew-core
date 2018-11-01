class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/index.html/uv/fossil-src-2.7.tar.gz"
  sha256 "2c24359131d7495e47dc95021eb35f1ba408ded9087e36370d94742a4011033c"
  head "https://www.fossil-scm.org/", :using => :fossil

  bottle do
    cellar :any
    sha256 "5c157a7a4ce7e0ac93d5fac860999e67a5858e81494022ebe7ef82a879d8e4f9" => :mojave
    sha256 "9cf69955de869e56cc70b48c6a2519c0cc4592d9d7ed75c1c508d2e48d7bd9eb" => :high_sierra
    sha256 "11dcf61299269e0befe82fd0e58337713b9492b4aafc89e6b91e032867b5d94c" => :sierra
  end

  depends_on "openssl"
  depends_on :osxfuse => :optional

  def install
    args = [
      # fix a build issue, recommended by upstream on the mailing-list:
      # https://permalink.gmane.org/gmane.comp.version-control.fossil-scm.user/22444
      "--with-tcl-private-stubs=1",
      "--json",
    ]

    if MacOS.sdk_path_if_needed
      args << "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
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
