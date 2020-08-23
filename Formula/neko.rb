class Neko < Formula
  desc "High-level, dynamically typed programming language"
  homepage "https://nekovm.org/"
  url "https://github.com/HaxeFoundation/neko/archive/v2-3-0/neko-2.3.0.tar.gz"
  sha256 "850e7e317bdaf24ed652efeff89c1cb21380ca19f20e68a296c84f6bad4ee995"
  license "MIT"
  revision 2
  head "https://github.com/HaxeFoundation/neko.git"

  bottle do
    cellar :any
    sha256 "a2c2e95b27fbe6a15ce0efc03a40655e2a283e3be08acdb0cc398a9367ec76a2" => :catalina
    sha256 "bb0f7ece136bfa89ac5d690f936f3ba0b34bd8e3a256f73260297e2a5f8e67eb" => :mojave
    sha256 "7697cb00ffbca3583c0633d042959beda280c6a5e9c3b802d0c14883a1cead88" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "mbedtls"
  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    inreplace "libs/mysql/CMakeLists.txt",
              %r{https://downloads.mariadb.org/f/},
              "https://downloads.mariadb.com/Connectors/c/"

    # Let cmake download its own copy of MariaDBConnector during build and statically link it.
    # It is because there is no easy way to define we just need any one of mariadb, mariadb-connector-c,
    # mysql, and mysql-client.
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
    (testpath/"hello.neko").write '$print("Hello world!\n");'
    system "#{bin}/nekoc", "hello.neko"
    assert_equal "Hello world!\n", shell_output("#{bin}/neko hello")
  end
end
