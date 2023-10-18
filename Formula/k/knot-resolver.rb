class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.7.0.tar.xz"
  sha256 "383ef6db1cccabd2dd788ea9385f05e98a2bafdfeb7f0eda57ff9d572f4fad71"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  revision 1
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git", branch: "master"

  livecheck do
    url "https://secure.nic.cz/files/knot-resolver/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "9db269775fc6ce2266790e19280a3330e781ec5afa3119bc4081e174a1c82a4c"
    sha256 arm64_ventura:  "b129c87a2134aa0ae49e0df544714fa17f0b66053cde08067e4ae29441201d80"
    sha256 arm64_monterey: "521d2e624647b10d9af77dae70f38e1c53201f107e4fea1a978a18198d01f478"
    sha256 arm64_big_sur:  "1de3b05f43d3b6087fceaf189fd78e2c384505af6715632be3c632b23fc22964"
    sha256 sonoma:         "7ab4f5f95f5e174d1cbe7ee9a29475188d0883e4c8a1e6da2ded5b95bc6b74d0"
    sha256 ventura:        "58dec4665c73538d7ea34b9e6f237374994818ac80391454994cb6338a8ab391"
    sha256 monterey:       "b5fa46c74e301df115e00cc638df6cad41d2c8b38911f9f24373e05c2780738c"
    sha256 big_sur:        "40776a6aa32b7fd5e43c47c836200e417c02ea99bda9bcc5416aa8bf597b314c"
    sha256 x86_64_linux:   "6a90e05c7193d7849a00dc4cf96cde98cb0b4f9060500ad037a4931585948a79"
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
