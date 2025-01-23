class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.7.4.tar.xz"
  sha256 "6b6da6ecf06828041afad44dfa227781f0ae34ad183a667008509355d18bd9c8"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git", branch: "master"

  livecheck do
    url "https://www.knot-resolver.cz/download/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t[^>]*?>[^<]*?stable/i)
  end

  bottle do
    sha256 arm64_sequoia: "08dd88e8e9fc10ef7494116e727723828e3e7d4f17e3fd96a204c828a5628945"
    sha256 arm64_sonoma:  "8d442104e77ea8cff29c84fdb5a7e4604ebc8e81c32d9a9e070138eb5cb6e22b"
    sha256 arm64_ventura: "f036e8ce8f5cf29c9996441ad4a479ac53534d6c83255c812526ac1c4831c790"
    sha256 sonoma:        "bfb3e2c794ec64de04cb3bffb98c77cd525b628e84e0333fc17b9f67bfb5daf8"
    sha256 ventura:       "acf867ac9bc8bea1f5095221acf661185c72523b288a1b3085057af455353aef"
    sha256 x86_64_linux:  "b357e992fd8676db35a50c6e93abed1008f7f16b79e72450093631d1e83576d1"
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
