class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.4.1.tar.xz"
  sha256 "fb8b962dd9ef744e2551c4f052454bc2a30e39c1f662f4f3522e8f221d8e3d66"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  revision 1
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git"

  livecheck do
    url "https://secure.nic.cz/files/knot-resolver/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "e0c8efeb9caa6e6fb4f134ab4d1f246f807a66f72376a43b3ad689a0d7502292"
    sha256 big_sur:       "31379c500b70b0d70012cf117762936110c690760eaedd0ba6082ada5f31ecd0"
    sha256 catalina:      "87c4877aaafd7e7840e24d164cc5df4203caafae54956aca01430f4189f35fc7"
    sha256 mojave:        "fa1691356793d077171f59e9b1fad7462f9b7c26cdaa0246223cafeb9e85cebf"
    sha256 x86_64_linux:  "01c4d2bca6d3e2ece73bc4754f2774e3065b801db3b56dd075f3f4a7d91e23b4"
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
