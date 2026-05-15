class MinLang < Formula
  desc "Small but practical concatenative programming language and shell"
  homepage "https://min-lang.org"
  url "https://github.com/h3rald/min/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "017178f88bd923862b64f316098772c1912f2eef9304c1164ba257829f1bbfc2"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "2ef803c82853b1b321beeafc765188f15dbec742127101fec848307fd3fe98d2"
    sha256 cellar: :any,                 arm64_sequoia: "71000cdcf6ff4197db8463e2bcdcfdbe06aeca5015b5d99bc2540bc586203a03"
    sha256 cellar: :any,                 arm64_sonoma:  "d2c9b6fa074041130942ce3d6920b72fbcafa19cdd430d3cb7d5aa587c472145"
    sha256 cellar: :any,                 sonoma:        "1b6a74a5d1854800edb8eab49013a818352c7f9b081324de871aa82adf49da21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb035bc0b1423297e5f251ae2ad2c3833f03ae343fda90867668eb73ea6f0b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8eb616acafc4d01b6a464c3d034ab13990837c1a0a2f7b808892fe877988ea82"
  end

  depends_on "nim"
  depends_on "openssl@3"
  depends_on "pcre2" => :no_linkage

  def install
    # Remove bundled libraries
    rm_r(["minpkg/vendor/openssl", "minpkg/vendor/pcre"])
    inreplace ["minpkg/lib/min_crypto.nim", "minpkg/lib/min_http.nim"], /passL: "-B?static /, 'passL: "'
    inreplace "minpkg/lib/min_global.nim", /passL: "-B?static (.*) -lpcre([" ])/, "passL: \"\\1\\2"

    system "nimble", "build", "--passL:\"-lssl -lcrypto -Wl,-rpath,#{rpath(target: Formula["pcre2"].opt_lib)}\""
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
