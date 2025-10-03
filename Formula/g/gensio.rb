class Gensio < Formula
  desc "Stream I/O Library"
  homepage "https://github.com/cminyard/gensio"
  url "https://github.com/cminyard/gensio/releases/download/v3.0.0/gensio-3.0.0.tar.gz"
  sha256 "67e621b47aa7cd7cdf148398cf99f8d8b606f2598e731207debd649dcf9ef5f0"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]

  bottle do
    sha256 arm64_tahoe:   "3f24e3984dff7c86b997c5acc7e75b030916d2f4e50fc632e6c54778fb4a765d"
    sha256 arm64_sequoia: "40677c845f93749b3f7b86f4d399a2383b4280ead8429d3edd31f90a8e3eaa54"
    sha256 arm64_sonoma:  "a02b158d13901cdf6b084d94c0d829bcf260c8e68de4d60abadd48859c63a9db"
    sha256 sonoma:        "379095d503b94140e55b993252044cd8739e735df2777b857054bc5aa19c62f5"
    sha256 arm64_linux:   "b0d6bfe2a4dcc23f477fce1714871405f06b13ad5895424b346bcb6c9bfc9f05"
    sha256 x86_64_linux:  "0e0f84a001b719f5a5d179fd4e474a3873e16205c201daf1818f54f693eb5a4a"
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
