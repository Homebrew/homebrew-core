class Gensio < Formula
  desc "Stream I/O Library"
  homepage "https://github.com/cminyard/gensio"
  url "https://github.com/cminyard/gensio/releases/download/v3.0.2/gensio-3.0.2.tar.gz"
  sha256 "f05e96d3497c4085c5493b36a3a6d5e25d8787a3de220135335f1ec93fca3637"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]

  bottle do
    sha256 arm64_tahoe:   "0db89caf2ed24a6fe56baad6d75e2c330f3d844615476130ed40c96886ce1d8e"
    sha256 arm64_sequoia: "68e9064b1dc71ee980b5249fe7c30dab5b48234b5be64bd6ef51c9e7cd097cbe"
    sha256 arm64_sonoma:  "8f5754c49d927f54546913cba4c3187df1b60a2e18672541c1d51d3738adc92a"
    sha256 sonoma:        "33301c2bd0538d62b33f72ab6ab7356b0de2d95416f2f85bad06467f3a87b072"
    sha256 arm64_linux:   "d28a9500f998e1e699484373c0044827613b2dc4e4707b6814fec1603604272b"
    sha256 x86_64_linux:  "0d72619224d245f776aa9866523a636f1546e1479fea40f928fde9e5af98961e"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "swig" => :build

  depends_on "glib"
  depends_on "openssl@3"
  depends_on "python@3.14"
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
    "python3.14"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
