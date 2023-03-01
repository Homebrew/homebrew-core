class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-community-3.21.0.tar.gz"
  sha256 "911778ddb0a4e03a3ddfc8fc0f033136e1551849ea2dcbdb3f0f14359dfe3126"
  license all_of: ["BSD-3-Clause", "GPL-2.0-or-later", "GPL-3.0-only", "LGPL-2.0-or-later"]

  livecheck do
    url "https://cfengine-package-repos.s3.amazonaws.com/release-data/community/releases.json"
    regex(/["']version["']:\s*["'](\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 arm64_ventura:  "27b951de5b5ee9627613dc7523d8e2292f1b232c69c471aad025b86e327adcd5"
    sha256 arm64_monterey: "09c2fa7bef3021135f30428c0a52f45c12c498d19c37484c046e82972e27a14a"
    sha256 arm64_big_sur:  "bba68b7b689885281fe39990a47465bed00b30e574398b7d6d8dd090a93af605"
    sha256 ventura:        "3ce88aadceac013e0766718411012c78f32a507f45026e71df07b202e944947e"
    sha256 monterey:       "face2e3238f646256c734e6bc8387e1f777be23022b3860d68690425bceff81c"
    sha256 big_sur:        "7d5cebadbb5b090776e1ccdad32efcca81c1f09685d024565be9f98a3b914ec6"
    sha256 x86_64_linux:   "70c2b4ce3295bce05b2f9173e888c1239f40f672cdff29def1ef92f4d26d1769"
  end

  depends_on "lmdb"
  depends_on "openssl@3"
  depends_on "pcre"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "linux-pam"
  end

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.21.0.tar.gz"
    sha256 "013ebe68599915cedb4bf753b471713d91901a991623358b9a967d9a779bcc16"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-workdir=#{var}/cfengine
      --with-lmdb=#{Formula["lmdb"].opt_prefix}
      --with-pcre=#{Formula["pcre"].opt_prefix}
      --without-mysql
      --without-postgresql
    ]

    args << "--with-systemd-service=no" if OS.linux?

    system "./configure", *args
    system "make", "install"
    (pkgshare/"CoreBase").install resource("masterfiles")
  end

  def post_install
    workdir = var/"cfengine"
    secure_dirs = %W[
      #{workdir}/inputs
      #{workdir}/outputs
      #{workdir}/ppkeys
      #{workdir}/plugins
    ]
    chmod 0700, secure_dirs
    chmod 0750, workdir/"state"
    chmod 0755, workdir/"modules"
  end

  test do
    assert_equal "CFEngine Core #{version}", shell_output("#{bin}/cf-agent -V").chomp
  end
end
