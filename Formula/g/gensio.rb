class Gensio < Formula
  desc "Stream I/O Library"
  homepage "https://github.com/cminyard/gensio"
  url "https://github.com/cminyard/gensio/releases/download/v2.8.9/gensio-2.8.9.tar.gz"
  sha256 "00bb5f0aa80d9978195f5efab5db403af22e5e7ed0f75c682da47577248bd333"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]
  revision 1

  bottle do
    sha256 arm64_sequoia: "ce409a565b24e29123c36ed03589dc36163ca20d5b63fa912aa8d99f0897a1b6"
    sha256 arm64_sonoma:  "8e023182c89ca34354319946f3076eb32c30cc041bfcaddf49e087a4c5c3ee63"
    sha256 arm64_ventura: "0afc017ded2668e8ae03981705e144d708d9c6d28b2ca73cc4cfd496f3ff8af7"
    sha256 sonoma:        "42b6952d37c4ea9085d608a7710de716020764bf89afe8eaaae783b8f725a674"
    sha256 ventura:       "63af45c369946d79d822a85c8664a1e174b1d6ec59706f390d6b494509391cf2"
    sha256 x86_64_linux:  "5a0f8ef0973ab5ac0b7dc803da81f00b1068db38bf1a5675dfff8df482148b72"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
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
