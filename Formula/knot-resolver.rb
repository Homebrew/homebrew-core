class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.5.1.tar.xz"
  sha256 "9bad1edfd6631446da2d2331bd869887d7fe502f6eeaf62b2e43e2c113f02b6d"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git", branch: "master"

  livecheck do
    url "https://secure.nic.cz/files/knot-resolver/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "6a517aa4fd0cf71cf8bba405930f7e03097ac1f99bf26e00bb6fb65405977688"
    sha256 arm64_big_sur:  "da4fa2b01f63f579f0d9b9ac01c84d77105496bd192b3548b9f72db87023bedc"
    sha256 monterey:       "8f76c7d1ad811ec13701a833704b59d8fd3c21a6fe148c4609b45ae81be0f794"
    sha256 big_sur:        "a606f9f8eeff2ff56218e1dace5346be4283fb86dc094c14cb91ebaab79098c4"
    sha256 catalina:       "e8c4d94dd7ac9427b6ea8438075f1648e32684ffae6b588a31d544e0a767a4cc"
    sha256 x86_64_linux:   "3837801e26b104c70cd25248740c2f9a7f59e0d63eaa026eebfc11bea09024d4"
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
