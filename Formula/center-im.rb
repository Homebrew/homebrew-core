class CenterIm < Formula
  desc "Text-mode multi-protocol instant messaging client"
  homepage "https://github.com/petrpavlu/centerim5"
  url "https://github.com/petrpavlu/centerim5/releases/download/v5.0.1/centerim5-5.0.1.tar.gz"
  sha256 "b80b999e0174b81206255556cf00de6548ea29fa6f3ea9deb1f9ab59d8318313"

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "182513b7096a23e8888d0d76858ad1c1d2ef92648f8f3d4140e291c41224ccbb"
    sha256 big_sur:       "2b44902a2be528a4d9cae18e3b402691dc54a4c2241e72827a74bafe422d85cf"
    sha256 catalina:      "11a339b812d7fa164fce8e873e837d1ab07256e73ce0c4e483eeb60327ef6fa6"
    sha256 mojave:        "42a8b8f09b9530139c5d9eaf7c83a435962c61631eea00a13bf70a670044c7a2"
    sha256 high_sierra:   "9b40fc34ba5177765f01bdd821bec40377f44828421509491d90fb7a329ba400"
    sha256 sierra:        "7e9f2db21d3ceec8ad7d3a59e5bf600d5d145aa0a88f676d803c1feea307f687"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl@1.1"

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/677cb38/center-im/patch-libjabber_jconn.c.diff"
    sha256 "ed8d10075c23c7dec2a782214cb53be05b11c04e617350f6f559f3c3bf803cfe"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-msn",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"

    # /bin/gawk does not exist on macOS
    inreplace bin/"cimformathistory", "/bin/gawk", "/usr/bin/awk"
  end

  test do
    assert_match "trillian", shell_output("#{bin}/cimconv")
  end
end
