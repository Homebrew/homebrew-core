class MinLang < Formula
  desc "Small but practical concatenative programming language and shell"
  homepage "https://min-lang.org"
  url "https://git.sr.ht/~h3rald/min/archive/v0.48.1.tar.gz"
  sha256 "baec4d176ff138fcf39784ad97a6a9125454a8d3ccb4db3e6ea59aa2d6716a45"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fa6272ef9e4977c79ef598c4b06b3a1e22211f79a8862b40b3a6a093f7014251"
    sha256 cellar: :any, arm64_sequoia: "86a190e4e9e51fc1c8ce39826a0f5431ac86e6c0dede686e0a14721edb4892f0"
    sha256 cellar: :any, arm64_sonoma:  "06700e980f16bd6e26ddd174b67c5fba9217aa392f118c01d1577884c94efea9"
    sha256 cellar: :any, sonoma:        "5fac5e0d8b7c806a5a229eeb83c80f1449f3f2f7da789d9ff1d1363940848a5b"
    sha256 cellar: :any, arm64_linux:   "3669a9f51363b901f54ae34da65ed0b834f02f77ebfdb9809d7641ee0babe11c"
    sha256 cellar: :any, x86_64_linux:  "e6d07ca9b67335e210dbdd07bf7c2e1fe91e6d3da5a6f2b827147687ece0ecc3"
  end

  depends_on "nim"
  depends_on "openssl@3"
  depends_on "pcre2" => :no_linkage

  def install
    # Remove bundled libraries
    rm_r(["minpkg/vendor/openssl", "minpkg/vendor/pcre"])
    inreplace ["minpkg/lib/min_crypto.nim", "minpkg/lib/min_http.nim"], /passL: "-B?static /, 'passL: "'
    inreplace "minpkg/lib/min_global.nim", /passL: "-B?static (.*) -lpcre([" ])/, "passL: \"\\1\\2"

    system "nimble", "build", "--passL:\"-lssl -lcrypto -Wl,-rpath,#{rpath(target: formula_opt_lib("pcre2"))}\""
    bin.install "min"
  end

  test do
    testfile = testpath/"test.min"
    testfile.write <<~EOS
      sys.pwd sys.ls (fs.type "file" ==) filter '> sort
      puts!
    EOS
    assert_match testfile.to_s, shell_output("#{bin}/min test.min")
  end
end
