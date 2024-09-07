class Gensio < Formula
  desc "Stream I/O Library"
  homepage "https://github.com/cminyard/gensio"
  url "https://github.com/cminyard/gensio/releases/download/v2.8.7/gensio-2.8.7.tar.gz"
  sha256 "900f8f83b76ba16f8c7839911bce77354e41f296f9fa677d7945d44ee8358276"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]

  bottle do
    sha256 arm64_sonoma:   "8731dd66aa9f37f3a0e1ec9ea39ef8529cf64eca5535fb207a58cfa5829a7268"
    sha256 arm64_ventura:  "2f80bb73cb338f9367b804137ab2de96bc2c649a44e968df3ae0ffd6842ef030"
    sha256 arm64_monterey: "a01edfa645981d37239686530cfe84cf42dd3922728ba3b4f46d14aee5f012a1"
    sha256 sonoma:         "81c724b7c4f3444e6692146f18e38e4b99dcddb0e9e7f12555390136fc04a453"
    sha256 ventura:        "5a8f19031d7d3a6e517730c704e14a06f63c5cd0d65cda62c7391bdcde563606"
    sha256 monterey:       "5c776d9fb7a6fee66d5065cf2eb930b45cf0ce0c201d7bd7dddf8279109e2fba"
    sha256 x86_64_linux:   "d432c24af7ea10460ddbaeb9f89b832b37eb25ed5af74c5d238be5000a3a74f4"
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
