class Gensio < Formula
  desc "Stream I/O Library"
  homepage "https://github.com/cminyard/gensio"
  url "https://github.com/cminyard/gensio/releases/download/v3.0.4/gensio-3.0.4.tar.gz"
  sha256 "e28c24fc5d9f3cb90005bc008fec8bb8eedce503753024ab650bed0ac250cbe3"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]
  revision 2

  bottle do
    sha256 arm64_golden_gate: "136af11ce4e9d4198a6b36e9c5a84b8b3b62d7b28e6fef7cde1e14ef39d9da00"
    sha256 arm64_tahoe:       "0a28339c40b788c31a013584dc2ef1e2333d3b692b8ccd46a1b1dee307efebee"
    sha256 arm64_sequoia:     "5767240b5c48ac251b0ced1e1cc6787c122e6306c235b197e73da61e4ad71568"
    sha256 arm64_linux:       "6b1626cddaf9165981c5f17fb9832af93d7465f034dd38bebfe3425e91bb2c0a"
    sha256 x86_64_linux:      "42a6784805b71b775280bd2d86dfd303d882101312e10db8b2fe392ce8133102"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "swig" => :build

  depends_on "glib"
  depends_on "openssl@4"
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

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    tcltk = Formula["tcl-tk"]
    args = %W[
      --disable-silent-rules
      --with-python=#{python3}
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
