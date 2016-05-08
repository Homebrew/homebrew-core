class Neko < Formula
  desc "High-level, dynamically typed programming language"
  homepage "http://nekovm.org"
  url "http://nekovm.org/media/neko-2.1.0-src.tar.gz"
  sha256 "0c93d5fe96240510e2d1975ae0caa9dd8eadf70d916a868684f66a099a4acf96"

  head "https://github.com/HaxeFoundation/neko.git"

  bottle do
    sha256 "7e236b71ffeeffbcd7b900e8eca1d918506369f04b384db636193e8fc749e60a" => :el_capitan
    sha256 "08e27a02801d60a36971ef04892c8737402d94611c8cce5e6abdfc0066f2d8ce" => :yosemite
    sha256 "fd20435ab471a197439ef8b15bc22e20ed63e5bee586b0a64d811a8a178a4c3b" => :mavericks
    sha256 "a45ce3f4eab713bea15f8b34045333462d3e6a971c10257b9789ffc8000951e2" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"
  depends_on "bdw-gc"
  depends_on "pcre"
  depends_on "openssl"

  patch do
    # To workaround issue https://github.com/HaxeFoundation/neko/issues/130
    # It is a commit already applied to the upstream.
    url "https://github.com/HaxeFoundation/neko/commit/a8c71ad97faaccff6c6e9e09eba2d5efd022f8dc.patch"
    sha256 "7bbdbd38f64220aa11fd1725ae99ea53f2d36563249f1828d5452562e3ca9977"
  end

  def install
    # Let cmake download its own copy of MariaDBConnector during build and statically link it.
    # It is because there is no easy way to define we just need any one of mariadb, mariadb-connector-c,
    # mysql, and mysql-connector-c.
    system "cmake", ".", "-DSTATIC_DEPS=MariaDBConnector", "-DRELOCATABLE=OFF", "-DRUN_LDCONFIG=OFF", *std_cmake_args
    system "make", "install"
  end

  def caveats
    s = ""
    if HOMEBREW_PREFIX.to_s != "/usr/local"
      s << <<-EOS.undent
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
