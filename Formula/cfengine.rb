class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-community-3.21.2.tar.gz"
  sha256 "e3f733433ff9ad86a01513b779f646da223afed8568e8de6e89c4e5aa8c6b256"
  license all_of: ["BSD-3-Clause", "GPL-2.0-or-later", "GPL-3.0-only", "LGPL-2.0-or-later"]

  livecheck do
    url "https://cfengine-package-repos.s3.amazonaws.com/release-data/community/releases.json"
    regex(/["']version["']:\s*["'](\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 arm64_ventura:  "1f68257cc6e3932557cd975f838b1615613081fe540027cb9496fc2f19c09178"
    sha256 arm64_monterey: "7e570928e99a9aa77d8305f5fd3464e697fe917fd8bb74771eee59efc3d5a680"
    sha256 arm64_big_sur:  "af2c6bd195bf4b47e3993985248156a28ae4f94eeb731116c8e153cde4c2b4e6"
    sha256 ventura:        "231fb89d5d2cb430a1133f454b9d3bf2b046b291c1094eb759043c736622ad42"
    sha256 monterey:       "bc9a6d359595208a7c725973fa0f14b5887c604ffb372e06f3f8f677ca658ebb"
    sha256 big_sur:        "8b7bfc6818fbe326faa1f30ec46c1211f5d724d02f6e1170dcc30603e9f0d2f9"
    sha256 x86_64_linux:   "6d8260ac10aae3a5e0651ecba9e86756eed5a6c307ad4c0d8f19a05a16c9c120"
  end

  depends_on "lmdb"
  depends_on "openssl@3"
  depends_on "pcre"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "linux-pam"
  end

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.21.2.tar.gz"
    sha256 "6fbaa12d602db8a94c89a6a4fec52f1e29bf27053ad8a35036c6f11e61827b1c"
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
    assert_equal version, resource("masterfiles").version, "`masterfiles` resource needs updating!"

    assert_equal "CFEngine Core #{version}", shell_output("#{bin}/cf-agent -V").chomp
  end
end
