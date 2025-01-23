class Gensio < Formula
  desc "Stream I/O Library"
  homepage "https://github.com/cminyard/gensio"
  url "https://github.com/cminyard/gensio/releases/download/v2.8.11/gensio-2.8.11.tar.gz"
  sha256 "ac39fb97ab6b85e468384bced70672d1d23d643aeaf79a687947194a74c049e8"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]

  bottle do
    sha256 arm64_sequoia: "bcadaa813fff53eb6f2a8348b1871ea5f1a6ef94d9dc3924e8925c483d2c17f1"
    sha256 arm64_sonoma:  "8b11a0c759c57e25aa5554ce462e0190ee344af9d5697b25eb532e3e500357a4"
    sha256 arm64_ventura: "9f4f57b7a5914e2e99517fd19685f251b861254d30b905061ef72612fc3fba90"
    sha256 sonoma:        "80abcde802af713b344a6ed7ffd8e4a3866bc8e985ebae58e3375bf8664fc738"
    sha256 ventura:       "ff38691633a984d72b80e9ee41872c537e8c1dacf8ea3e1a1a5701c1da11c022"
    sha256 x86_64_linux:  "6f5ae1b22dfe4c13cb64c948045ffbd1bb59734e77f6aa36ffa57bd79775e864"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "swig" => :build

  depends_on "glib"
  depends_on "openssl@3"
  depends_on "python@3.13"

  uses_from_macos "tcl-tk"

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
    args = %W[
      --disable-silent-rules
      --with-python=#{which(python3)}
      --with-pythoninstall=#{lib}/gensio-python
      --sysconfdir=#{etc}
    ]
    args << "--with-tclcflags=-I#{HOMEBREW_PREFIX}/include/tcl-tk" if OS.linux?

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
