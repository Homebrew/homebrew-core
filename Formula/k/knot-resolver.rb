class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.7.6.tar.xz"
  sha256 "500ccd3a560300e547b8dc5aaff322f7c8e2e7d6f0d7ef5f36e59cb60504d674"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  revision 1
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git", branch: "master"

  livecheck do
    url "https://www.knot-resolver.cz/download/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t[^>]*?>[^<]*?stable/i)
  end

  bottle do
    sha256 arm64_tahoe:   "6eba212c347984073fc9d40e134202867ae0cbfb8e25cd247b5943335ae86e2f"
    sha256 arm64_sequoia: "125e0626c3a093255a706cfd558ee53c75cec4adfa08e1f001c214c6d37a15a6"
    sha256 arm64_sonoma:  "ddaeaf61ebbec2f0f02c63552c1e53cf341b36a89484873a4594d04417ed12d0"
    sha256 sonoma:        "4b83b4b7c1f48bce2dd0e3a8d6fd854c4d57dac8addeafa93ee59693b6c35709"
    sha256 arm64_linux:   "a44b90de3037d1f0247dbf2d94455f81ba45ffe332335a6075e1c0b3b559a0e9"
    sha256 x86_64_linux:  "5da6935c2d96ed81f408b87a859613a16e730ff1a616b56350eca31a59951310"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fstrm"
  depends_on "gnutls"
  depends_on "knot"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "lmdb"
  depends_on "luajit"
  depends_on "protobuf-c"

  on_linux do
    depends_on "libcap-ng"
    depends_on "libedit"
    depends_on "systemd"
  end

  def install
    args = ["--default-library=static"]
    args << "-Dsystemd_files=enabled" if OS.linux?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    (var/"knot-resolver").mkpath
  end

  service do
    run [opt_sbin/"kresd", "-c", etc/"knot-resolver/kresd.conf", "-n"]
    require_root true
    working_dir var/"knot-resolver"
    input_path File::NULL
    log_path File::NULL
    error_log_path var/"log/knot-resolver.log"
  end

  test do
    assert_path_exists var/"knot-resolver"
    system sbin/"kresd", "--version"
  end
end
