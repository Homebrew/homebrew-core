class Gensio < Formula
  desc "Stream I/O Library"
  homepage "https://github.com/cminyard/gensio"
  url "https://github.com/cminyard/gensio/releases/download/v3.0.4/gensio-3.0.4.tar.gz"
  sha256 "e28c24fc5d9f3cb90005bc008fec8bb8eedce503753024ab650bed0ac250cbe3"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]
  revision 2
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "060ca9f89e9d2deaf99e760862a2126681eb6ec47442b36ddf32a5b35312583f"
    sha256 arm64_tahoe:       "a5c3a8ab7365409caf6f4dcff3502026bf14e282d9481632a41e8f39895515d7"
    sha256 arm64_sequoia:     "b564a7a57d9f33c88a38986d60946fcf615f86b2d574179e4e497f9a8f07f40d"
    sha256 arm64_linux:       "9f2bb6bb84500d9e09b0bdfcd35b19ade960da515cb8c7ae79424e7e89654c89"
    sha256 x86_64_linux:      "bbd5f2a8eca323b5f842a7c2fa0ee925b441f50787daa146783d4a5aaea69492"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "swig" => :build

  depends_on "glib"
  depends_on "openssl@4"
  depends_on "python@3.15"
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
