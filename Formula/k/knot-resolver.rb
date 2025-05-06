class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.7.5.tar.xz"
  sha256 "80239cf9aa92599d9cbad4642dea5520b2ccfbc9c6f968886ea46179cb3cdf66"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git", branch: "master"

  livecheck do
    url "https://www.knot-resolver.cz/download/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t[^>]*?>[^<]*?stable/i)
  end

  bottle do
    sha256 arm64_sequoia: "7c9948c0d651f2f405019d6520a7bdabd3ed904ecff54a92073acbc1ab014e12"
    sha256 arm64_sonoma:  "3382cbd84482ce8d977890d16dc5fd139d84162211b01f33ecf641d7d865a257"
    sha256 arm64_ventura: "5e7d78a4ab9ecbbaf643eb14ade1dfa991a2ffc149d6635a6cf515ed3376de13"
    sha256 sonoma:        "99b6758c6c51f508e4b8600a6c6346c3f69f564d39147c70e9b9de417f92e757"
    sha256 ventura:       "8a6308b7ae198d484897098798ec9e33689daa69ecd398400bfa46c48bad2845"
    sha256 arm64_linux:   "7595f507c065b5d75db23481182422861f43dafdde405d6cba8c87dff9284518"
    sha256 x86_64_linux:  "4fb9a214783e990eae3f0eac0160b441c13c7083545c78db400d49258cbcba44"
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
