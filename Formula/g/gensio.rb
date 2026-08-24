class Gensio < Formula
  desc "Stream I/O Library"
  homepage "https://github.com/cminyard/gensio"
  url "https://github.com/cminyard/gensio/releases/download/v3.0.4/gensio-3.0.4.tar.gz"
  sha256 "e28c24fc5d9f3cb90005bc008fec8bb8eedce503753024ab650bed0ac250cbe3"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]

  bottle do
    sha256 arm64_tahoe:   "7cf85625c9588a9d12c6ae72fb8039ca03bd5d7b46087e216f02c12ecb4193c9"
    sha256 arm64_sequoia: "c7d02cc1451278dc1cdd9053e6b9207912d1e1e3aa9f05feca195c30b3339948"
    sha256 arm64_sonoma:  "624e7f57297490067bae297467bc75bcc22fb851d4886d53264c29e51534421c"
    sha256 sonoma:        "cd1b75a48babd6d3a3ed118aa612b6ba4510b5b9b9da40ace9c0248db324b37c"
    sha256 arm64_linux:   "e587dc19dcdc948d6c80b12cd58e8847e9d507cddb685343e42d9261895cecb9"
    sha256 x86_64_linux:  "3bd5149aa658a458e4e45b4ccf1a9f08aa50ee46203bf9a4ef664bf0c437722e"
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
