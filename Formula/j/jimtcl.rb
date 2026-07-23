class Jimtcl < Formula
  desc "Small footprint implementation of Tcl"
  homepage "https://jim.tcl.tk/index.html"
  url "https://github.com/msteveb/jimtcl/archive/refs/tags/0.84.tar.gz"
  sha256 "435095b436b38b96dd85e8cda13878144813bf52066057f76368db178dd8fea2"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_tahoe:   "49d6948c10c245e1c3899d99310de49518f5497a9cd0e19e5cc47a28d6c2d515"
    sha256 arm64_sequoia: "07154ce642692bfc22ef3fb224c9929e638ba4cc2afc9ba180febf692f53992c"
    sha256 arm64_sonoma:  "54bb0f7df7b58b73403d3676da646c1dbab63ff74af371afa5bb2edc7aeeb0ae"
    sha256 sonoma:        "c372398df5a9c148ce18ead99dec80f0e1345561b6ce6a8b6480b74def2c88b0"
    sha256 arm64_linux:   "7b8e364487eec1cd03f69fa5fa3278b7da756964d2643cff0574f30c88b59be7"
    sha256 x86_64_linux:  "33f1669740e1f0587137e8eb19ffaf3b43522de37d15a6ca160b5f8d57cd7025"
  end

  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # patch to include `stdio.h``
  patch do
    url "https://github.com/msteveb/jimtcl/commit/35e0e1f9b1f018666e5170a35366c5fc3b97309c.patch?full_index=1"
    sha256 "50f66a70d130c578f57d9569b62cf7071f7a3a285ca15efefd3485fa385469ba"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--with-ext=readline,rlprompt,sqlite3",
                          "--shared",
                          "--docdir=#{doc}",
                          "--ssl",
                          *std_configure_args
    system "make"
    system "make", "install"
    pkgshare.install Dir["examples*"]
  end

  test do
    (testpath/"test.tcl").write "puts {Hello world}"
    assert_match "Hello world", shell_output("#{bin}/jimsh test.tcl")
  end
end
