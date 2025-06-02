class Gensio < Formula
  desc "Stream I/O Library"
  homepage "https://github.com/cminyard/gensio"
  url "https://github.com/cminyard/gensio/releases/download/v2.8.15/gensio-2.8.15.tar.gz"
  sha256 "1cfa7d6ef19b8d98808b1f4bce225454781299f885815c22ab59d85585f54ee3"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]

  bottle do
    sha256 arm64_sequoia: "55f26f4519d626685977d8698f239dd144b28d5dff6f2bd08182335f6026af4d"
    sha256 arm64_sonoma:  "a26e4a132a4f4099ce49f56c17b7c24f0e509a9e944ef54634151b10c02657dc"
    sha256 arm64_ventura: "e2a24dac5ea15c6235327c5028e8ed34e59e09c64e35830e1f7f4b699c3e5987"
    sha256 sonoma:        "74eced1fc82f3d172aee5eef3194d8e5e401f160fd1554c85c3352f6bf305ecf"
    sha256 ventura:       "f76906e1351966419ed1617b3cba3fa43ab37f1b9dd4d4dc2547f15604336325"
    sha256 arm64_linux:   "7849c953dc4d197d70ecc835d47b25e7de0f0cd51a2b02b163570ab79fbe0dcd"
    sha256 x86_64_linux:  "f0654ac13d972321059009c5d0b971b3c7a7206239bc6db5045125e0a04b283e"
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
