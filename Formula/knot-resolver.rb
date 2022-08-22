class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.5.2.tar.xz"
  sha256 "3f78aa69c3f28edc42b5900b9788fba39498d8bffda7fb9c772bb470865780cb"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  revision 1
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git", branch: "master"

  livecheck do
    url "https://secure.nic.cz/files/knot-resolver/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "eb1a18669a91b27acb41dd0146b7d5f63a0ffa238bb2392d90bb6c255608a7f2"
    sha256 arm64_big_sur:  "3d62e6d4b077d016fc35b9ba88e836f20d13946988eb1ae52aa60312dc0ff97b"
    sha256 monterey:       "8a08f505b301e475d6fe4446d39c168948bfbe37ec433cf331c50053fd1fbc28"
    sha256 big_sur:        "a21720afa463758117fb31978e868bf66a48619a5f2cdf7de620b510456e99e3"
    sha256 catalina:       "dafd4e15aa868b11720d8ef75438d83bef988e69c726dcfee8f09e677b57603c"
    sha256 x86_64_linux:   "4ebfa24dff8650caf6ebbd43b0ca36db6c5502f3924bd28e981777241fd0ca46"
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
