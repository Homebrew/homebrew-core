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
    sha256 arm64_monterey: "aa60fed5e36e677b7843ab045ccc8d4b66e341bac8dc3a4fd99480e982be00b4"
    sha256 arm64_big_sur:  "dff8edd10a1f2a2e3b283ad2c88a554e6c600744677ca2c64e237c6864d7e802"
    sha256 monterey:       "79b62244153cba5951ae5bc810375152469abc193af8c70dd62d262b6f9ab648"
    sha256 big_sur:        "b993d89162baab37487e3165f55292c31d867620cabc5bec0c947d0a3ae6a8de"
    sha256 catalina:       "d4bb924c828107d1bd9466a9dabb33a08c8e8921d1686b3238a0181c6336ee18"
    sha256 x86_64_linux:   "381e7a3a31baf315b5239dd71ee844c1289335b286687ed48d92850b4ab4d50d"
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
