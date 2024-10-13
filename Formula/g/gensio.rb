class Gensio < Formula
  desc "Stream I/O Library"
  homepage "https://github.com/cminyard/gensio"
  url "https://github.com/cminyard/gensio/releases/download/v2.8.9/gensio-2.8.9.tar.gz"
  sha256 "00bb5f0aa80d9978195f5efab5db403af22e5e7ed0f75c682da47577248bd333"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]

  bottle do
    sha256 arm64_sequoia:  "2fbbf769092237b2ad692909a156018d332448cd4f9746d4500a7e9fe6246341"
    sha256 arm64_sonoma:   "815af93c530cceb6397e6bb7c562f075d2365778f8b5737eafacba3701c90fc8"
    sha256 arm64_ventura:  "6fefc05cde05c6b163c5b5172d7c37521bf3e3c709fbd4d9ed5a20e7b804470e"
    sha256 arm64_monterey: "b7ced27a12b0b7b82943387d985ba0f306038a3a720d7befd0b42afe4dc290aa"
    sha256 sonoma:         "adf86af724ab78586bded8df4c1042acac126d7568c248f5ad17f890b2c0d9bc"
    sha256 ventura:        "9474bf1436704a1745dce9b1d8f6aea8b294fd17553e23fa3c5f19d413223595"
    sha256 monterey:       "411f1e3c17029edbf1634508a1a53c0df79cbcf007d394eeb59ff0dcbf04902a"
    sha256 x86_64_linux:   "557f6c57c37b8b39caed264af6b9c3194573e279891dd99d7d4149cedb1a3e1d"
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
