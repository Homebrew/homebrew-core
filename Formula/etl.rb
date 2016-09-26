class Etl < Formula
  desc "Extensible Template Library"
  homepage "http://synfig.org"
  url "https://downloads.sourceforge.net/project/synfig/releases/1.0.2/source/ETL-0.04.19.tar.gz"
  sha256 "ba944c1a07fd321488f9d034467931b8ba9e48454abef502a633ff4835380c1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "7275d40af2ee9e99feec8a04a9296b1167b24ca8f7125a875d08c13b4913e81b" => :sierra
    sha256 "10244415e0dbf71f94c7585595632a09773a49dbc5bf5ac8de7e062f29c7f2b4" => :el_capitan
    sha256 "29198ad9d848f2ff79b224a5467da1fb22a474de5ffc3e287196fd3822a45178" => :yosemite
    sha256 "024271929c1e3de9d4c4e256a932fa9525395f7421fc174e7010251ab9a4b37e" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <ETL/misc>
      int main(int argc, char *argv[])
      {
        int rv = etl::ceil_to_int(5.5);
        return 6 - rv;
      }
    EOS
    flags = %W[
      -I#{include}
      -lpthread
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
