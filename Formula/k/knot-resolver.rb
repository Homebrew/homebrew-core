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
    sha256 arm64_sonoma:   "ca3e061098bf62a05472b8848b9878323507158825dc5eba3859aec145eef2c0"
    sha256 arm64_ventura:  "92d971d8ea1a7869f3137997f0d57eb7979f22a17c979005341b5d4b0926c9de"
    sha256 arm64_monterey: "2331dbb17923e62fea433d75e7df52571d25afc2554d594f66a4b64ab4b1fc40"
    sha256 sonoma:         "5baee71ea5371ab075c20a4bec31ce979151d5ea280b3879fcd554d6f7dd0c9d"
    sha256 ventura:        "59c31aa06e7e22f558cb68e77abb32bb21ee2c5ec17c7f4a7d995685a13a66b6"
    sha256 monterey:       "0a2a9f882b02b45fd1f579f4fbbd8c07ad435ad3c3d8b0f1016044c17d78a2bc"
    sha256 x86_64_linux:   "a77943712ac31be3dc450e80958b4d89cb591e94c5c7d7437cdfa9de82249e5d"
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
