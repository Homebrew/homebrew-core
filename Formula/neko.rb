class Neko < Formula
  desc "High-level, dynamically typed programming language"
  homepage "https://nekovm.org/"
  url "https://github.com/HaxeFoundation/neko/archive/v2-2-0/neko-2.2.0.tar.gz"
  sha256 "cf101ca05db6cb673504efe217d8ed7ab5638f30e12c5e3095f06fa0d43f64e3"
  revision 6
  head "https://github.com/HaxeFoundation/neko.git"

  bottle do
    sha256 "e4d68665d504273468b38a5891c938d59080147677abfc718967e11eeb70ce5d" => :mojave
    sha256 "396aea7bce27dcba88338f6698036c097864a172732742e04bfac4815fc7c7e7" => :high_sierra
    sha256 "12be1d612bea5f7efbca986107ea498edec85d610e7df6abde68c95a07e5746c" => :sierra
    sha256 "0054a53a378dc7ab95c74fff99f80a3bd15b927fe87204635b728a9bbdc2b866" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "mbedtls"
  depends_on "openssl"
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
