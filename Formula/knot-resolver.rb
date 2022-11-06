class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.5.3.tar.xz"
  sha256 "a38f57c68b7d237d662784d8406e6098aad66a148f44dcf498d1e9664c5fed2d"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  revision 1
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git", branch: "master"

  livecheck do
    url "https://secure.nic.cz/files/knot-resolver/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "12dbcfb549ef5b68b6a6a6fcf9b7fc47602ebccc92f455086d4092efaa158f64"
    sha256 arm64_monterey: "de3f1e1f8fea0e292f9acea823802778a1d40c1c4bda863ba343d51117acaf85"
    sha256 arm64_big_sur:  "b3546f2546f4a2c9a62c815530eb72577050eebb74fa6051c6b4259556a8aa0d"
    sha256 ventura:        "cb391b0b9e7392dcdcc5a2e86dcc760ae4eff483395339b4cf34ed25eb43ade3"
    sha256 monterey:       "072de42c2782eb5022257d1c0b4f4161cc8f049fcb27b897a8d026d506f710d8"
    sha256 big_sur:        "e0f5dea3577e23596ceaa94049c7aac2e2d80617d9cab5da3a70a3e5eb51581f"
    sha256 catalina:       "efc2b3769d9097e9cb34c5265f105e25372502511e7eeb11efdfba804dc28f79"
    sha256 x86_64_linux:   "937ea3e6cccfe623ac7ecb6483e5ff4c6823bd3be7a198668e84646fa0a93f4f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "knot"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "lmdb"
  depends_on "luajit"

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

  service do
    run [opt_sbin/"kresd", "-c", etc/"knot-resolver/kresd.conf", "-n"]
    require_root true
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
