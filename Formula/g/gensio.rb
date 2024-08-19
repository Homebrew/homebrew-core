class Gensio < Formula
  desc "Stream I/O Library"
  homepage "https://github.com/cminyard/gensio"
  url "https://github.com/cminyard/gensio/releases/download/v2.8.5/gensio-2.8.5.tar.gz"
  sha256 "00183e41e857972993a92b702420473d610f1f6e6834d621ccb9e27dd9123596"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]

  bottle do
    sha256 arm64_sonoma:   "36b40f799255dce8b906e8b6861ea76ab1cab487f671ba85564911c817733727"
    sha256 arm64_ventura:  "f9b22df824a9318e9ef2b444b2c0fe2053a2a03e300f620baed052521aa2319b"
    sha256 arm64_monterey: "3af244d023ec018d00cf0974b41434f572dfdf557bf8fde43abfb4872a0b44c7"
    sha256 sonoma:         "cf07d4666ca9ee3c0eb16bcf3123d29b7a03fb6eba7025afffd3f6841f30518e"
    sha256 ventura:        "47da8cc5a1a440515fc760ee1e42156ae7594d3f207f71e93c4526aff14c5139"
    sha256 monterey:       "2428c9d0e2e3d71a86241943c6da4d9f704b8662b8e0241dfa106389c410a187"
    sha256 x86_64_linux:   "39bb8dc41d3c547299356e9613b11cb1236c09e68cb015b564e4ea8768811ae4"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build

  depends_on "glib"
  depends_on "openssl@3"
  depends_on "portaudio"
  depends_on "python@3.12"

  uses_from_macos "tcl-tk"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "avahi"
    depends_on "linux-pam"
    depends_on "systemd"
    depends_on "tcl-tk"
  end

  def python3
    "python3.12"
  end

  def install
    args = %W[
      --disable-silent-rules
      --with-pythoninstall=#{lib}/gensio-python
      --sysconfdir=#{etc}
    ]
    args << "--with-tclcflags=-I #{HOMEBREW_PREFIX}/include/tcl-tk" if OS.linux?
    system "./configure", *args, *std_configure_args
    system "make", "install"
    (prefix/Language::Python.site_packages(python3)).install_symlink Dir["#{lib}/gensio-python/*"]
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
