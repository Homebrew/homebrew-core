class Grap < Formula
  desc "Language for typesetting graphs"
  homepage "https://www.lunabase.org/~faber/Vault/software/grap/"
  url "https://www.lunabase.org/~faber/Vault/software/grap/grap-1.48.tar.gz"
  sha256 "89a1b02b162fbb4ad9827ebfe97a2b31f3923bf06996381a9e5f806d350584b9"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?grap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "b788c5d7bff50a5e551f67f8ff38481e42057d0123a02aae466ec38a2e01febe"
    sha256 arm64_sonoma:   "aee0fb925a7b696bf99148451165a0ca69ecf103f8643ca99b268059b19fcec1"
    sha256 arm64_ventura:  "cc5a9165ecc68e108f25c9137d1d0a97f77ab1bf98dae4e8c061ef784292655d"
    sha256 arm64_monterey: "6be5b79b4875ae0cf474928cef30768193449bebf139672328ad5a81ce152e9e"
    sha256 sonoma:         "86976bbb29c4d47f3bf59c5a0065b6dd9905ba24377862f58d94847743e1835d"
    sha256 ventura:        "d6c281e795d7afc04167a13a6e903461c2dd319aa62240ee7361c82b3ab3c248"
    sha256 monterey:       "73c7bde75b91da23b0e29acad4e10f39e5bc9347f2107f535698a8ac07e9fcdd"
    sha256 x86_64_linux:   "464831eb93ac8007e97497163960ba9c91b6c17dba21f2178ea26863080a8d1e"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-example-dir=#{pkgshare}/examples"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.d").write <<~EOS
      .G1
      54.2
      49.4
      49.2
      50.0
      48.2
      43.87
      .G2
    EOS
    system bin/"grap", testpath/"test.d"
  end
end
