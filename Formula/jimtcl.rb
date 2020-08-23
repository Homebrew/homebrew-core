class Jimtcl < Formula
  desc "Small footprint implementation of Tcl"
  homepage "http://jim.tcl.tk/index.html"
  url "https://github.com/msteveb/jimtcl/archive/0.79.tar.gz"
  sha256 "ab8204cd03b946f5149e1273af9c86d8e73b146084a0fbeb1d4f41a75b0b3411"
  license "BSD-2-Clause"

  bottle do
    sha256 "c91b95aea2acc6fe7d469cddf8dbde23ce65f1ace79619f89d5352f4bd38f3e7" => :catalina
    sha256 "22ab871e18afe4bccfd40f169050f2629382f9964de4bf441b593e951e586d2c" => :mojave
    sha256 "0962cd4e3b386a6bdf463d023a21c4d296c17711d413501b6781b0b69cdcdc01" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--full",
                          "--with-ext=readline,rlprompt,sqlite3",
                          "--shared",
                          "--docdir=#{doc}",
                          "--maintainer",
                          "--math",
                          "--ssl",
                          "--utf8"
    system "make"
    system "make", "install"
    pkgshare.install Dir["examples*"]
  end

  test do
    (testpath/"test.tcl").write "puts {Hello world}"
    assert_match "Hello world", shell_output("#{bin}/jimsh test.tcl")
  end
end
