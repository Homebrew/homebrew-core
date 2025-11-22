class Gensio < Formula
  desc "Stream I/O Library"
  homepage "https://github.com/cminyard/gensio"
  url "https://github.com/cminyard/gensio/releases/download/v3.0.1/gensio-3.0.1.tar.gz"
  sha256 "06e02f45003d163ca2d94137ba920ea9b683b75f63321ab7dc21f742246a123a"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]

  bottle do
    sha256 arm64_tahoe:   "fd79c10fc9b60585f18b0bc8bbeeff260995b47c3ea71084945eadeb54ef847b"
    sha256 arm64_sequoia: "d9a21ff517cd927f96817fd5e27847016f8c14114f4bae6f7501f478a2c2edb3"
    sha256 arm64_sonoma:  "09523c5739cd4b126d26e514f212efc29cdb82a20e9800cb9d4f7fffed23c966"
    sha256 sonoma:        "008b0c3ba4492bc34a36c9babde6a4416e8dc0e8f8ceb05728529ff84d424e73"
    sha256 arm64_linux:   "d1ed1a3fbe94e26dbeb2eb276812c9019a45822accad660b0208760f6d185d5b"
    sha256 x86_64_linux:  "97528052ad99d3b85b73ec1fea8e52003e153bdd0995e70785b6be7d6cc2a1d7"
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
