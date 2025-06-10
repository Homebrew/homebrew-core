class Iipsrv < Formula
  desc "High performance image server for high resolution and scientific images"
  homepage "https://iipimage.sourceforge.io"
  url "https://downloads.sourceforge.net/iipimage/IIP%20Server/iipsrv-1.3/iipsrv-1.3.tar.bz2"
  sha256 "d4bdfd137bcd7856d49fafddb15c03913ae00ff781672f8239d0ca0988cfc752"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{ url=.*?/iipimage/files/IIP%20Server/.*?[-_/](\d+(?:[-.]\d+)+)[-_/%.]}i)
  end

  depends_on "pkgconf" => :build
  depends_on "fcgi"
  depends_on "jpeg-turbo"
  depends_on "libavif"
  depends_on "libmemcached"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openjpeg"
  depends_on "webp"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  service do
    run [opt_sbin/"iipsrv", "--bind", "0.0.0.0:9000"]
    environment_variables LOGFILE: "/dev/stdout", URI_MAP: "iiif=>IIIF"
    log_path var/"log/iipsrv.log"
    keep_alive crashed: true
  end

  test do
    # Test whether iipsrv is able to create log file
    ENV["LOGFILE"] = testpath/"iipsrv.log"
    assert_equal "", shell_output(sbin/"iipsrv", 1)
    assert_path_exists testpath/"iipsrv.log"
  end
end
