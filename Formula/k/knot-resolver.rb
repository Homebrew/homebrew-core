class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.7.2.tar.xz"
  sha256 "5f6a227390fcd4c2d0a8028a652b55a9d863ec7be01298fe038df1d273fb9a0f"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git", branch: "master"

  livecheck do
    url "https://secure.nic.cz/files/knot-resolver/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f5b50cd761834cdfe16e03717dcbdd08e56dd46f7cc8247cb17dd3ba8dfe2b41"
    sha256 arm64_ventura:  "4e703c18bffa0042f49681079126eb44291d0f40294501a8513c0c354ce2e754"
    sha256 arm64_monterey: "45db8c6cd8cab7f6689b30958647b38c8c74dcf9d3be104b67ae12654d9f3b21"
    sha256 sonoma:         "48c8d2533a57a71ad7d5e6ac41256eec3f7f352c88bbe4b1f95fac7b83c8cc0e"
    sha256 ventura:        "42f8f4799f7cbd270f9a8e080e9b36c5ba9f1689e1646367fd69ccd2e6239c7e"
    sha256 monterey:       "4b735a8f787d82128743c1f5c65c61d06576a11a6cfe6c49901682ae34fcdbc4"
    sha256 x86_64_linux:   "0971d3c13d39522ff6b651b0db22346a4875fcf2407b1295339df1b9f8ed009e"
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
    input_path "/dev/null"
    log_path "/dev/null"
    error_log_path var/"log/knot-resolver.log"
  end

  test do
    assert_path_exists var/"knot-resolver"
    system sbin/"kresd", "--version"
  end
end
