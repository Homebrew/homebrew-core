class Neko < Formula
  desc "High-level, dynamically typed programming language"
  homepage "http://nekovm.org"

  head "https://github.com/HaxeFoundation/neko.git"

  stable do
    url "http://nekovm.org/media/neko-2.1.0-src.tar.gz"
    sha256 "0c93d5fe96240510e2d1975ae0caa9dd8eadf70d916a868684f66a099a4acf96"

    patch do
      # To workaround issue https://github.com/HaxeFoundation/neko/issues/130
      # It is a commit already applied to the upstream.
      url "https://github.com/HaxeFoundation/neko/commit/a8c71ad97faaccff6c6e9e09eba2d5efd022f8dc.patch?full_index=1"
      sha256 "a5d08e5ff2f6372c780d2864b699aae714fc37d4ab987cea11764082757ddb39"
    end

    patch do
      # Fix issue https://github.com/HaxeFoundation/neko/issues/173
      # It is based on commits already applied to the upstream.
      url "https://github.com/HaxeFoundation/neko/compare/d3bf5be89b57e55a686b470b90a1ed912499ad1d...ac8952276c1c799dc3162a43a6bc54fa037fad68.patch"
      sha256 "96ca3ad8bae5c67fe84d60ce9f73d73e8ec0948bfe57058e2739c883118b15de"
    end
  end

  bottle do
    cellar :any
    sha256 "e7eac782a1eefa0c284c6ac03a7aee6dfce36d171b867495c218b7fff0373e59" => :high_sierra
    sha256 "d13f59694764fdb51b946227c0c2f6d32fcfaf2c2539d7428a270b641c8f03a6" => :sierra
    sha256 "96f0c125a3269f52d691fa6fe8a9dcbfc0d71dcf949b76acd004631e28ce2d81" => :el_capitan
    sha256 "4d1aa0431be615afa6207a56fecc30a79fe39d1e6e53c7ff84c4f075eda8ddeb" => :yosemite
    sha256 "db1b96e4f313b1d1d138449a63b921e17b4a6bdb8ef8733d7b806bda3272fead" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"
  depends_on "bdw-gc"
  depends_on "pcre"
  depends_on "openssl"

  def install
    # make has problem doing parallel build using nekoc/nekoml.
    ENV.deparallelize

    # Let cmake download its own copy of MariaDBConnector during build and statically link it.
    # It is because there is no easy way to define we just need any one of mariadb, mariadb-connector-c,
    # mysql, and mysql-connector-c.
    system "cmake", ".", "-DSTATIC_DEPS=MariaDBConnector", "-DRELOCATABLE=OFF", "-DRUN_LDCONFIG=OFF", *std_cmake_args
    system "make", "install"
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
