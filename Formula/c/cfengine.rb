class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-community-3.22.0.tar.gz"
  sha256 "c2e7ac88d2371fda2809e0bbd3a3908cab50592b6c1479353bd18ba809b93528"
  license all_of: ["BSD-3-Clause", "GPL-2.0-or-later", "GPL-3.0-only", "LGPL-2.0-or-later"]

  livecheck do
    url "https://cfengine-package-repos.s3.amazonaws.com/release-data/community/releases.json"
    regex(/["']version["']:\s*["'](\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 arm64_sonoma:   "2a9889b513ec33c49aa38362d2bb35d2da9ad09a1b58d90c1b4c21cc839151a4"
    sha256 arm64_ventura:  "015b04d8465581173060924e86777a960531ccff34dee65d3b6758ca076841f2"
    sha256 arm64_monterey: "3ebb2118a1c6e42c8641249b14d5f3febbd08b67dccf608f169fa6cad71f5e48"
    sha256 arm64_big_sur:  "420ef43f40fc4f871ec83902e1c4388c4fe32499de45982de41f3e08b488ebd9"
    sha256 sonoma:         "62a2c79b8e4b6720f5b85ffe94014cb94a93ee9843e99231b53c94aeae9c159a"
    sha256 ventura:        "c3a086085d47322e84e5c6ddc50a8bb82767f4609c5caea9ae0a906f99c13286"
    sha256 monterey:       "42eed03205b9d617c4e9d2f9181faee1bc9c854799bc4f380a33f0c4b0a07b69"
    sha256 big_sur:        "f0cb272965fc3727754d71b4544f29ed432fef2efea743f29e0e273ed03af4ed"
    sha256 x86_64_linux:   "9f01d7f6ce91e60b9e19871da800a5f2355cec0df3db1462f8d01e0d4d1d6cbb"
  end

  depends_on "lmdb"
  depends_on "openssl@3"
  depends_on "pcre"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "linux-pam"
  end

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.22.0.tar.gz"
    sha256 "5eae6ba6881de1aef4f8115cd6b6ecb0c0809c7ea956b7097a99d62c014506ea"
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
