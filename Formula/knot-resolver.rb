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
    sha256 arm64_monterey: "131e5893ab226a79750ddc151bcd7eca63762c418727b36b1d15bf680bdbd39f"
    sha256 arm64_big_sur:  "736748fa882bed12ee084acc67435616e951ec5774da0aad0d10d07a108c6a0d"
    sha256 monterey:       "e3dd4d3bdefc14ecb0bf360f30d07b3172e99749f10f049a6c042c87707eb75c"
    sha256 big_sur:        "91c736136510175a44cd0c0df17132f7b98bbbd2d2f4dbea275c301223c72bc8"
    sha256 catalina:       "e15d1538bdb72b0a9ef8c8938e986cd78b5bf7af77998e339e3100e4f43d62ae"
    sha256 x86_64_linux:   "f0da0cf368c5f24b001c0e9fd433d33bc0012628340044f894e7e4c542d83203"
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
