class Gensio < Formula
  desc "Stream I/O Library"
  homepage "https://github.com/cminyard/gensio"
  url "https://github.com/cminyard/gensio/releases/download/v2.8.14/gensio-2.8.14.tar.gz"
  sha256 "a3492c9e5c1e4ee8b5e5410eaf3a07b6bfc523069252f4a0a0a39e6d255f0db7"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]

  bottle do
    sha256 arm64_sequoia: "4db0e5b42bc4649a74056bd5d3575b36307575e0143227371d62bcb003f744c4"
    sha256 arm64_sonoma:  "82b52a62b06d606e76fe23bfb3ac622be2bb9f25359002ffab3c5f2901e547c8"
    sha256 arm64_ventura: "14de2aa1520cfceb48b4e1abe8e66f64861479883e9188319444e8041606762e"
    sha256 sonoma:        "60b6e107edff098919627fb22a74b6003cfd3df8284e39a25aae0faedbd8ba6f"
    sha256 ventura:       "3a5c486d602d84c84434b367b9cd941c71f0e8e57ef0e35a2ac50d79fe68f89c"
    sha256 arm64_linux:   "d740791e93ab78d2277b3049b4633cb048864d8e322a2abd6e238443588c1aa2"
    sha256 x86_64_linux:  "3185a44ed3a947e1ba77236f870a2908776e44fb866006f169c3ad94bbc30c72"
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
