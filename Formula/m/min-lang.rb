class MinLang < Formula
  desc "Small but practical concatenative programming language and shell"
  homepage "https://min-lang.org"
  url "https://github.com/h3rald/min/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "20b836d87a99a801859b99e5f08ef39fe1b787d642f053926db5e39955ddf4d4"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ea94a2c1f41db54447f306f26bba8bcfea7e163083cf8f68ce29818a36efb54f"
    sha256 cellar: :any, arm64_sequoia: "f9bc539aa6b39e96d6d796c5011922ad488556370190d2c333561fdc305168a8"
    sha256 cellar: :any, arm64_sonoma:  "6bc01f2fafa372cd6f80600e639cdea1b5952eee18a51ab286c4339879b59736"
    sha256 cellar: :any, sonoma:        "f8163ffea30e28d48bf203dd80da5711b30f338cc9626340fd4a3cc5d6303245"
    sha256 cellar: :any, arm64_linux:   "6378198c85520572b86c5dba8d33696cb143e11730f1f5e9bc16cce0cdbf3a99"
    sha256 cellar: :any, x86_64_linux:  "95f14a18f33b0921984b0104232f015d67ed5a5069ca814bf1677ac47554dab1"
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
