class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.19.0.tar.gz"
  sha256 "bb43b23f76e6bd4f54e250675cfe8a01376326fa2c6c63c2a9e9bd091685d867"
  license all_of: ["BSD-3-Clause", "GPL-2.0-or-later", "GPL-3.0-only", "LGPL-2.0-or-later"]

  livecheck do
    url "https://cfengine-package-repos.s3.amazonaws.com/release-data/community/releases.json"
    regex(/["']version["']:\s*["'](\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 arm64_monterey: "c81d7e7a9eec367bcd794ea9dc4092f3292552fdb1269b1df89c31d24a54abc1"
    sha256 arm64_big_sur:  "9d1a150197ac82f23e8cc662a1e26019c1d12a47d89409646931911dfb890917"
    sha256 monterey:       "2abde0aecb5b42972d16b36ac21a4c7c10f6eb010b66a89e3af66ad354677893"
    sha256 big_sur:        "e4592faa5446d14f19d2deef600ec505f33ccbbe12e4284084e74ea14bf9246d"
    sha256 catalina:       "1de581c225d466b87d19f3685e422959ad6a0383aa2fae0160cc3cb47c340979"
    sha256 x86_64_linux:   "6d423a86c4e6b6150c21cd05046da345f8f7ec17be971257b5529559182d1001"
  end

  depends_on "lmdb"
  depends_on "openssl@1.1"
  depends_on "pcre"

  on_linux do
    depends_on "linux-pam"
  end

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.18.1.tar.gz"
    sha256 "b9f5554a9122861a9a13acb2e3920c2887c309f898685713f1a35ba5be741772"
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

  test do
    assert_equal "CFEngine Core #{version}", shell_output("#{bin}/cf-agent -V").chomp
  end
end
