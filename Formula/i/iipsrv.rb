class Iipsrv < Formula
  desc "High performance image server for high resolution and scientific images"
  homepage "https://iipimage.sourceforge.io"
  url "https://downloads.sourceforge.net/iipimage/IIP%20Server/iipsrv-1.2/iipsrv-1.2.tar.bz2"
  sha256 "d2483313d62eb617d05f3a55c5f09551fe5165725faba63aca680cb87d56bf6c"
  license "GPL-3.0-or-later"

  depends_on "pkg-config" => :build
  depends_on "fcgi"
  depends_on "jpeg-turbo"
  depends_on "libmemcached"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openjpeg"
  depends_on "webp"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    sbin.install "src/iipsrv.fcgi" => "iipsrv"
    man8.install "man/iipsrv.8"
  end

  service do
    run [opt_sbin/"iipsrv", "--bind", "0.0.0.0:9000"]
    environment_variables LOGFILE: "/dev/stdout"
    log_path "#{var}/log/iipsrv.log"
    keep_alive crashed: true
  end

  test do
    # Test whether iipsrv is able to create log file
    ENV["LOGFILE"] = testpath/"iipsrv.log"
    assert_equal "", shell_output(sbin/"iipsrv", 1)
    assert_path_exists testpath/"iipsrv.log"
  end
end
