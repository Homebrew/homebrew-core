class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.4.1.tar.xz"
  sha256 "fb8b962dd9ef744e2551c4f052454bc2a30e39c1f662f4f3522e8f221d8e3d66"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git"

  livecheck do
    url "https://secure.nic.cz/files/knot-resolver/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "c4cd7cccb96bd54ceb76b8f04c95269fc639474c85c917eb03206eaf6d8aee34"
    sha256 big_sur:       "3ee0b70bb08e528285d2c1c211a0e933324b1f742c8499b42f3b1f17f141c425"
    sha256 catalina:      "550aa7baeabf7ab4ad234cd8ec60112e56c43b9023cc66b9b456e1a9c2a93491"
    sha256 mojave:        "78a20463807a612d481736d6e5dc8f9dacf6cbc6df96006bd1fd022efa9088b6"
    sha256 x86_64_linux:  "0ba3e84407b27a59138f60f1e08df6ffc830e0fb87247ad156c991c5a5478e3f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "knot"
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
