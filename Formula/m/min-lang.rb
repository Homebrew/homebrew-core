class MinLang < Formula
  desc "Small but practical concatenative programming language and shell"
  homepage "https://min-lang.org"
  url "https://git.sr.ht/~h3rald/min/archive/v0.48.1.tar.gz"
  sha256 "baec4d176ff138fcf39784ad97a6a9125454a8d3ccb4db3e6ea59aa2d6716a45"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9ba7d908e8927e6e24c9d67c47e42dd0b93b78134ca7f71ce008d378836dccfd"
    sha256 cellar: :any, arm64_tahoe:       "85d885093ce1e6278883aad1c181aff2697ab6d31ea824c0a8fc45829ff424a2"
    sha256 cellar: :any, arm64_sequoia:     "b67aaaf74e17823951657eaafb271c530bbb73ef69c5e135bb7a2316c4d99839"
    sha256 cellar: :any, arm64_linux:       "6769211ce2049d407d41d7d1f5f4973f22b22112c16b23f33d31dc15c99b2766"
    sha256 cellar: :any, x86_64_linux:      "86dbf1981a452a9abcc2371b1b3de738071cea459c4248402965ef0a7de8fddd"
  end

  depends_on "nim"
  depends_on "openssl@4"
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
