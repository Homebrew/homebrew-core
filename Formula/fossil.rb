class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/index.html/uv/fossil-src-2.7.tar.gz"
  sha256 "2c24359131d7495e47dc95021eb35f1ba408ded9087e36370d94742a4011033c"
  head "https://www.fossil-scm.org/", :using => :fossil

  bottle do
    cellar :any
    rebuild 1
    sha256 "1f166b784e43e79f1d093e1aeac2b1d805704652204b385e8ac24f6f45e03f92" => :mojave
    sha256 "069768fe35f9cda0bad842b90a7d10f1b4c813554403b7f4023ba5cb73a8427b" => :high_sierra
    sha256 "f6dcc3ac3c4c0f7c3ee2d96b0dcf43705a1853b60705f84e6aab2273e32bcdca" => :sierra
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
