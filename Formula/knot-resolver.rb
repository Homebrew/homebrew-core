class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.5.0.tar.xz"
  sha256 "4e6f48c74d955f143d603f6072670cb41ab9acdd95d4455d6e74b6908562c55a"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git", branch: "master"

  livecheck do
    url "https://secure.nic.cz/files/knot-resolver/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "00a6b08095cf50df34c95a4045fed42b15a8f4aa25d7233dfe60744f76272f54"
    sha256 arm64_big_sur:  "50b5f1de099fc2abfcc0884d62a1c62fb891a83d4f0394b1474c8f8c2903eddd"
    sha256 monterey:       "25bd87b99ee1628ae8e1b5d141c0f7ed05475aca252c76b659ab2353c0ab49f8"
    sha256 big_sur:        "bee12b1f2fbbfb70c441ee447baf892f90ae61807edb18abdfc40f474e2d224f"
    sha256 catalina:       "77f451db9bc36f6710e928e1b905da2f2b86249fad3af4ec685a66748885b111"
    sha256 x86_64_linux:   "06625a977631bd6db573b45631324db57107bc98885927ff714367180a7feefb"
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
