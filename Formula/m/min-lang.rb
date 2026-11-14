class MinLang < Formula
  desc "Small but practical concatenative programming language and shell"
  homepage "https://min-lang.org"
  url "https://git.sr.ht/~h3rald/min/archive/v0.48.1.tar.gz"
  sha256 "baec4d176ff138fcf39784ad97a6a9125454a8d3ccb4db3e6ea59aa2d6716a45"
  license "MIT"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "42bb96674527a495de466c096dbe2036e57c5171d48b4c6ff7bc02e25c916e8b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "acd0b9d8103075210e4a98887b144d37c8e1bfac09b68a0377610b34e800fad5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5653b9a583a31ef5927eb66f72422322c2d7de976d26f4ab75a68b2dca986313"
    sha256 cellar: :any,                 arm64_linux:       "7aafcc785fbdd38851e4085b64dad3764e4de537320d6714bfafeba9c233693b"
    sha256 cellar: :any,                 x86_64_linux:      "7f9117649bcbac5c30d8f2c4f1437e91c93a96c6ce952f1a03987c7e23c1df61"
  end

  depends_on "nim"
  depends_on "openssl@4"

  on_linux do
    disable! date: "2027-11-13", because: "needs EOL `pcre`"

    depends_on "pcre"
  end

  deny_network_access!

  def fetch
    system "nimble", "install", "--depsOnly"
  end

  def install
    # Remove bundled libraries
    rm_r(["minpkg/vendor/openssl", "minpkg/vendor/pcre"])
    inreplace_files = ["minpkg/lib/min_crypto.nim", "minpkg/lib/min_http.nim", "minpkg/lib/min_global.nim"]
    inreplace inreplace_files, /passL: "-B?static /, 'passL: "'

    system "nimble", "build"
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
