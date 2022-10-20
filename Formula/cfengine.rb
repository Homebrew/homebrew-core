class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.20.0.tar.gz"
  sha256 "5a2ec814137bde6cc1ee35a81a78544bbf0a18282cd4307404c3a36ed1f7c4c8"
  license all_of: ["BSD-3-Clause", "GPL-2.0-or-later", "GPL-3.0-only", "LGPL-2.0-or-later"]

  livecheck do
    url "https://cfengine-package-repos.s3.amazonaws.com/release-data/community/releases.json"
    regex(/["']version["']:\s*["'](\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 arm64_monterey: "a670b2d8d6798b60e014861d33a03ec7ffa1a92be20318c229f5f7f103a950f8"
    sha256 arm64_big_sur:  "345dd97cead01bef152249188308372d56e81f88aad2136740ca483ff365ce9a"
    sha256 monterey:       "0955ee45e6250716784ab57c5b57a6700d7c4c68adec81cc198eb6221cd4a638"
    sha256 big_sur:        "76fd3b393e53ad84bc370aeb4a78eaf3c1f147ebb2f2ea7e228d3820986d67d9"
    sha256 catalina:       "d4c88a63b0fd86dbe31389c36cb029f51ab5444833cfa410ba2ee7c0fcd2144d"
    sha256 x86_64_linux:   "645e4be57258152d2f5b5ac9904c0ba0fddd97ee9db1386a35ac65b8be7ec8d0"
  end

  depends_on "lmdb"
  depends_on "openssl@1.1"
  depends_on "pcre"

  on_linux do
    depends_on "linux-pam"
  end

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.20.0.tar.gz"
    sha256 "a408cc2d3f4dcd64b698fa327b384208e7852305ebd69c8b9f2354df2d75fc76"
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
