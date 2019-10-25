class Neko < Formula
  desc "High-level, dynamically typed programming language"
  homepage "https://nekovm.org/"
  url "https://github.com/HaxeFoundation/neko/archive/v2-3-0/neko-2.3.0.tar.gz"
  sha256 "850e7e317bdaf24ed652efeff89c1cb21380ca19f20e68a296c84f6bad4ee995"
  head "https://github.com/HaxeFoundation/neko.git"

  bottle do
    cellar :any
    sha256 "290c4bad61fcce09531602bdb7520180f0b4f534aa18198d34d85ac77554d060" => :catalina
    sha256 "57d9215dc2d4077c372eb290caf8ffa2880f768b0a80d5743e369d9c520434e2" => :mojave
    sha256 "3bac4aaff119dddac74dd73056ff243ba78a398c2d052aad75d935b5b16cac93" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "mbedtls"
  depends_on "openssl" # no OpenSSL 1.1 support
  depends_on "pcre"

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
