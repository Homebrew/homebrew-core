class Fcgene < Formula
  homepage "https://sourceforge.net/projects/fcgene/"
  url "https://downloads.sourceforge.net/project/fcgene/fcgene-1.0.7.tar.gz"
  sha256 "4e1f85f2ec812e2528bd19b6c18ecf297666cd83046e003bc57d9ed5f25783d6"

  def install
    # upstream Makefile ignores $CXX
    ENV["AC_CXX"] = ENV["CXX"]
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.ped").write("1 1000000000 0 0 1 1 0 0 1 1\n1 1000000001 0 0 1 2 1 1 1 2\n")
    (testpath/"test.map").write("1 rs0 0 1000\n1 rs10 0 1001\n")
    system "#{bin}/fcgene", "--ped", "test.ped", "--map", "test.map"
  end
end
