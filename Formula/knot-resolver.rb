class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.6.0.tar.xz"
  sha256 "0c82ae937b685dc477fb3176098e3dc106c898b7cd83553e5bc54dccb83c80d7"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git", branch: "master"

  livecheck do
    url "https://secure.nic.cz/files/knot-resolver/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "5ca10e63c6082ebbd34e44e53f955022ee86f41f76171bc3f0442b75bc11df79"
    sha256 arm64_monterey: "a7cf2a04f6eb227f6cb40a2b020a181df5e8c0e079a2639e17a61fe88d71ba47"
    sha256 arm64_big_sur:  "de3ab727f527992c33269355569cf16bcd2c106d8df028d78b5088a1cf90669f"
    sha256 ventura:        "1b3af6eb07c55fe1024092a11cb8026328c35e77e4b623a4c1b9656438624c50"
    sha256 monterey:       "1d2600e90bdecc21f41ce437920fdaf111ad8992fbcff1ba16788d8fb395fe87"
    sha256 big_sur:        "077ab810b11de8686206f95b1164c86cf519ad93e5fc5e65259ee7de2bb3ac83"
    sha256 x86_64_linux:   "3b70cd4bce30b89bb79e609f0dfa06b31095f640be7ea3039f07c9a5e715d054"
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
