class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.4.2.tar.xz"
  sha256 "ea6a219571a752056669bae3f2c0c3ed0bec58af5ab832d505a3ec9c4063a58b"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git"

  livecheck do
    url "https://secure.nic.cz/files/knot-resolver/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "452c25e1ae99d18a9a1b46357644b43f0edb0b89460e444dbba49fbed6e39d71"
    sha256 arm64_big_sur:  "cacea8251a555de1f374ad7a62d4b33bd73181f429e235cedc4de8be00090097"
    sha256 monterey:       "8b61ef0569ab3a124830b8f0c71106dfdbd490a5e4b130c46cf0597da5f384de"
    sha256 big_sur:        "91405319bf4bce33774c1ef2c42802d5405c12cb74c87637206266444de3163b"
    sha256 catalina:       "afe54507119237bae07e93a5f975032db883061e062638dad73489afb1935dde"
    sha256 mojave:         "d7b924de8d80867a074635aae109dc7af1814425e4a0ba159f271ba9c8b8732d"
    sha256 x86_64_linux:   "3ac89256654cabe6135e52677a28e133997d832aceeb39e5edd4a21e1a40ed1a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "knot"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "lmdb"
  depends_on "luajit-openresty"

  on_linux do
    depends_on "libcap-ng"
    depends_on "systemd"
  end

  def install
    args = std_meson_args + ["--default-library=static"]
    args << "-Dsystemd_files=enabled" if OS.linux?

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    (var/"knot-resolver").mkpath
  end

  plist_options startup: true
  service do
    run [opt_sbin/"kresd", "-c", etc/"knot-resolver/kresd.conf", "-n"]
    working_dir var/"knot-resolver"
    input_path "/dev/null"
    log_path "/dev/null"
    error_log_path var/"log/knot-resolver.log"
  end

  test do
    assert_path_exists var/"knot-resolver"
    system sbin/"kresd", "--version"
  end
end
