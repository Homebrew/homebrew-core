class Gensio < Formula
  desc "Stream I/O Library"
  homepage "https://github.com/cminyard/gensio"
  url "https://github.com/cminyard/gensio/releases/download/v3.0.0/gensio-3.0.0.tar.gz"
  sha256 "67e621b47aa7cd7cdf148398cf99f8d8b606f2598e731207debd649dcf9ef5f0"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "f457b2ff887d4185b42cdbc10d84add3917d22ca11fae4e1ee20a2ada1e9521c"
    sha256 arm64_sonoma:  "96b46ed061f5e25c0c311f12d382d0a23b4122ac01fbe0bf3f0a75d30271c24e"
    sha256 arm64_ventura: "49728197d847378132c23682ab2de37655f4b4839f350ef761377d78aa98f72c"
    sha256 sonoma:        "2d0c0744dbe3bccca04aa55874165036386436b400aac7a9f008d62780f3e0a3"
    sha256 ventura:       "d84654ff3a63796d51f6cc4ce1dcb5029f12a66f6d246f111ac6e0db533d009d"
    sha256 arm64_linux:   "1516dd344ba741c695f5f8294ae74022e0206eda6e5aa5a869ba005630977fcc"
    sha256 x86_64_linux:  "9b133b00d37f8aa4ddf4c924f67f39444d16e6def67fcdbb010f7ae49d015dd2"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "swig" => :build

  depends_on "glib"
  depends_on "openssl@3"
  depends_on "python@3.13"
  depends_on "tcl-tk"

  on_macos do
    depends_on "gettext"
    depends_on "portaudio"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "avahi"
    depends_on "linux-pam"
    depends_on "systemd"
  end

  def python3
    "python3.13"
  end

  def install
    tcltk = Formula["tcl-tk"]
    args = %W[
      --disable-silent-rules
      --with-python=#{which(python3)}
      --with-pythoninstall=#{lib}/gensio-python
      --with-tclcflags=-I#{tcltk.opt_include}/tcl-tk
      --with-tcllibs=-ltcl#{tcltk.version.major_minor}
      --sysconfdir=#{etc}
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
    (prefix/Language::Python.site_packages(python3)).install_symlink lib.glob("gensio-python/*")
  end

  service do
    run [opt_sbin/"gtlsshd", "--nodaemon", "--pam-service", "sshd"]
    keep_alive true
    require_root true
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gensiot --version")

    assert_equal "Hello World!", pipe_output("#{bin}/gensiot echo", "Hello World!")
  end
end
