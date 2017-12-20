class Neko < Formula
  desc "High-level, dynamically typed programming language"
  homepage "https://nekovm.org/"
  url "https://github.com/HaxeFoundation/neko/archive/v2-2-0/neko-2.2.0.tar.gz"
  sha256 "cf101ca05db6cb673504efe217d8ed7ab5638f30e12c5e3095f06fa0d43f64e3"
  head "https://github.com/HaxeFoundation/neko.git"

  bottle do
    cellar :any
    sha256 "e7eac782a1eefa0c284c6ac03a7aee6dfce36d171b867495c218b7fff0373e59" => :high_sierra
    sha256 "d13f59694764fdb51b946227c0c2f6d32fcfaf2c2539d7428a270b641c8f03a6" => :sierra
    sha256 "96f0c125a3269f52d691fa6fe8a9dcbfc0d71dcf949b76acd004631e28ce2d81" => :el_capitan
    sha256 "4d1aa0431be615afa6207a56fecc30a79fe39d1e6e53c7ff84c4f075eda8ddeb" => :yosemite
    sha256 "db1b96e4f313b1d1d138449a63b921e17b4a6bdb8ef8733d7b806bda3272fead" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"
  depends_on "bdw-gc"
  depends_on "pcre"
  depends_on "openssl"

  def install
    # Let cmake download its own copy of MariaDBConnector during build and statically link it.
    # It is because there is no easy way to define we just need any one of mariadb, mariadb-connector-c,
    # mysql, and mysql-connector-c.
    system "cmake", ".", "-G", "Ninja", "-DSTATIC_DEPS=MariaDBConnector",
           "-DRELOCATABLE=OFF", "-DRUN_LDCONFIG=OFF", *std_cmake_args
    system "ninja", "install"
  end

  def caveats
    s = ""
    if HOMEBREW_PREFIX.to_s != "/usr/local"
      s << <<~EOS
        You must add the following line to your .bashrc or equivalent:
          export NEKOPATH="#{HOMEBREW_PREFIX}/lib/neko"
        EOS
    end
    s
  end

  test do
    ENV["NEKOPATH"] = "#{HOMEBREW_PREFIX}/lib/neko"
    system "#{bin}/neko", "-version"
  end
end
