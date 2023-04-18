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
    rebuild 1
    sha256 arm64_ventura:  "0a56cdf797ef67920aef33f08dc9003de945bb4b8537fac05217cdde5362c448"
    sha256 arm64_monterey: "3562db8dc457f1b10d5c8613a794d339c965fcfff16afbd18a594d7d0399ba53"
    sha256 arm64_big_sur:  "2b31713dd96b8effed6b0ad3fd526dea82d846d37289aa086af34684b283eb0e"
    sha256 ventura:        "bb84a9389272a98be63b3c17638eea7d7f7174691a0f2b3b23596b23564f7217"
    sha256 monterey:       "397bfb71c7b503c06c43cd625a7c8a5fe8a91f7635eeee93283456dc153d8f1d"
    sha256 big_sur:        "f9165e5051febf9bd586986e0b24dcad339040cafb64a059f87e6a1613718f9a"
    sha256 x86_64_linux:   "fe883b67118f2dc184afef455214c4d32cbbe380e9b1218bce672a680c31fc4d"
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
