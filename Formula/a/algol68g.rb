class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.5.0.tar.gz"
  sha256 "a5ee7221bea6da80a529e65d13ad56ff0c3cf334e709d6f4e16002d40d5af418"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "965cf03999e4f89b2f7dba96c1e44f50f18309b51f692c5bc36053ecbd5341fc"
    sha256 arm64_ventura:  "706b869a2dd00164260c4e87a1c651d66cf9f4f89f9338cffe06703232b2778b"
    sha256 arm64_monterey: "0bddb8363ce20c721f99811e763c2859eeb202a515663f0dd70c17752190e227"
    sha256 sonoma:         "5b600df1695d3d01f629c058aa50c8acac8a841a2bfae5d57d46b64702877a44"
    sha256 ventura:        "3b1428418976d3e67e1e531ba34a662c4ac92946437922a3f9ae28c18e5bad0c"
    sha256 monterey:       "bb0c035e9687f1ff619c8bf94c2041218b5ce94f8d638b23594794e45f5f00b2"
    sha256 x86_64_linux:   "e9b1fa26ec140a82860d0117c23e672f667cbcaecc4504e993cc4ef9087c2f50"
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
