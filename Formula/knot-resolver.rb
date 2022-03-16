class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.5.0.tar.xz"
  sha256 "4e6f48c74d955f143d603f6072670cb41ab9acdd95d4455d6e74b6908562c55a"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git", branch: "master"

  livecheck do
    url "https://secure.nic.cz/files/knot-resolver/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b1db8a9e181b036f6122fe8cb83089d8f451f594d6a34032b27e58ea66da793d"
    sha256 arm64_big_sur:  "4ec405fdef8c144a00d35476fbb21b569755fd1ae09c3b103408f517936c4a4c"
    sha256 monterey:       "d36b64e2ec17cb4ff5b06172cb5933a7e1b5513f1bd1d026819bc9dc45f6409d"
    sha256 big_sur:        "9014ad846f4b11d71d1d93c674c1b84f97565167e3e095892133e0bee4e8fd04"
    sha256 catalina:       "563a96d9410b904657f2af7e5534c4dc8d1677b46a61b4dc6f89b32da05eea3d"
    sha256 x86_64_linux:   "249d48e86d8b9f41d68706d9e3a7b18ee3f263fbf41db32ac2c276ae406cd822"
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
