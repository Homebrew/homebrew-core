class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.7.6.tar.xz"
  sha256 "500ccd3a560300e547b8dc5aaff322f7c8e2e7d6f0d7ef5f36e59cb60504d674"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git", branch: "master"

  livecheck do
    url "https://www.knot-resolver.cz/download/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t[^>]*?>[^<]*?stable/i)
  end

  bottle do
    sha256 arm64_tahoe:   "848d1af022ba7cd17848e7ecd899d64a1573b1b02c4fe496399c0e82d21caa6a"
    sha256 arm64_sequoia: "f842973a4b59ecfd29b822af797c426fc3d3fd6f460148a00d7fd297fcbd0a5c"
    sha256 arm64_sonoma:  "668a2e770862f3f7cbc480447752230034442bc1125b1baeebebe5617fcc5301"
    sha256 arm64_ventura: "5a8af2813cffb869b80e9295e7a7d6a6b215868d52dd531458d40b5d0fd22bc4"
    sha256 sonoma:        "e88a09cdb2d3fcf92bf4af7b48a4ab4a4c0076f8dbaa63ed5b0f424c23007e89"
    sha256 ventura:       "e98d27346d5199cfb6b0cf2cc33734f19b6e08cbdcbe4afddd59c52492022818"
    sha256 arm64_linux:   "6fe63f84fd4982b1d710b3453e6a6b9672df1fff80a808ee0bed1acec3ae8839"
    sha256 x86_64_linux:  "ad052ae5a64e60bfcd6c7a3e359588360e705387546f7eedc8ef7c8bed6872f8"
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
