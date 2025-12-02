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
    rebuild 1
    sha256 arm64_tahoe:   "1f4e8c8b8887350ccdb7390086e1b7801b222156d134442f267a7b9aed78a51b"
    sha256 arm64_sequoia: "a6b6768dc8c34d29219ffe92dac699ceaaa47c1dc081a881a0242aa90645b56f"
    sha256 arm64_sonoma:  "44258b442a01bcc0864c182993e4c50f46fdf0f844e577194ed17262c3fe48c0"
    sha256 sonoma:        "d7d2ef0fa2d4cd4505042fd6dcfb3a0f1e8ab09eed7c2ef3c324006e0d01ee65"
    sha256 arm64_linux:   "702b118e0dccb1554cd4298139176a0a55771f58fdaa8205c9bc1adaed702d2e"
    sha256 x86_64_linux:  "5faab59789f3df52ad937170ab984012ebbaf69c1edb68e82341a4d6e11b5285"
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

  uses_from_macos "libedit"

  on_linux do
    depends_on "libcap-ng"
    depends_on "systemd"
  end

  def install
    args = []
    args << "-Dsystemd_files=enabled" if OS.linux?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

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
