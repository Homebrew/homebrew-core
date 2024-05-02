class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.5.1.tar.gz"
  sha256 "4845849d4c3b28fce6effefb5867a458f928ca06136bca74120ba4a63265bb45"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "d3e85d719d8705a5967a67ea62854ba912acc3ad76ada0d1e7714c7cb54a9ce4"
    sha256 arm64_ventura:  "924fbb7b648a6c8d42cb99df290e732b4996d7594b01521e36f4da2bca6bf98d"
    sha256 arm64_monterey: "e6c9bd3b3d09edb872a41d9082fea2222e9f7abe224d121785f2a6a5b83ed9a9"
    sha256 sonoma:         "14ca58c1558ac63fc4cb508700ac77476074be0cbf0d0a5ff5cb6202501ddef3"
    sha256 ventura:        "098e5579b4fb21a84f49a05aced6187c9b7f327a879f4097bcae559cf9292fa1"
    sha256 monterey:       "c1483c50d1590ee418a18a9a8dba85fef88f8a64e1f243488e5de9193edbb4ac"
    sha256 x86_64_linux:   "52a9b078560c32ef4956a402c80887b38eb868fb8bbdd8f83c96c10d2cefce4b"
  end

  on_linux do
    depends_on "libpq"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
