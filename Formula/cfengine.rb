class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-community-3.21.1.tar.gz"
  sha256 "a4ff3acfc97362042ecb6f9ae03bc3ca5951c3b0c5ba08de8ca89078519960da"
  license all_of: ["BSD-3-Clause", "GPL-2.0-or-later", "GPL-3.0-only", "LGPL-2.0-or-later"]

  livecheck do
    url "https://cfengine-package-repos.s3.amazonaws.com/release-data/community/releases.json"
    regex(/["']version["']:\s*["'](\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 arm64_ventura:  "3ec34b91d62d80b62a11bd44426b4809ec8d90a01c3a2235c242b66cb13070f3"
    sha256 arm64_monterey: "7e4e79ce0f274958a9f6f71d4475cc00aab88b0ab90638444c364fa9ee781c49"
    sha256 arm64_big_sur:  "fecdd50aac6d1c2254691165304da9b5ca2aa002f34b3bdd2456ab64f8ae9cba"
    sha256 ventura:        "2e3765ddefe22657493c966a72d10e817bfc2bf1111607b2bb92652d26b1c3a5"
    sha256 monterey:       "806cb57af12a8e26b2fea5a5df27b379c53ad59c8368fc339bd044b8d3105718"
    sha256 big_sur:        "cbaa07ce152579195d278cae0ae39d966511ec538a12ffe2fce2e438e5309dfa"
    sha256 x86_64_linux:   "e29d2246046179714f0cc9833c6969ede28a425a76d68b1eb1e4a9dfa8673c7b"
  end

  depends_on "lmdb"
  depends_on "openssl@3"
  depends_on "pcre"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "linux-pam"
  end

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.21.1.tar.gz"
    sha256 "0ac6b06d2135260e9e047669bb34a3555b2b0e7ef8918a12fe71b59e95bae64f"
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
