class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.4.4.tar.xz"
  sha256 "588964319e943679d391cc9c886d40ef858ecd9b33ae160023b4e2b5182b2cea"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git", branch: "master"

  livecheck do
    url "https://secure.nic.cz/files/knot-resolver/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "52f65d3c9bbabfdc92a811ac45bbe2ba1748d9e686c9d5169ac38b170bcb5ef8"
    sha256 arm64_big_sur:  "4f6e6586cddb3a3d4ac9a6abfdabf021b49e8ecca72f6045845e60b4d4333c25"
    sha256 monterey:       "2cd27fef96a55ee3b441a5766adc27db908ee7b7356698142a0aec2ae7d46f59"
    sha256 big_sur:        "8505a179f4b2752c2368f3274fcbbd5f89406e9b0f71202a4738457da5ea00bc"
    sha256 catalina:       "3dbbb7600e370ab1257cca131062df27f6b91d969516f4c8229281627b346dff"
    sha256 x86_64_linux:   "f10362034e3e83b3e970edd07e77d2c23ff0bc4392206aad36b5cc8331f66ffe"
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
