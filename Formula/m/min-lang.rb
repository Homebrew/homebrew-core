class MinLang < Formula
  desc "Small but practical concatenative programming language and shell"
  homepage "https://min-lang.org"
  url "https://github.com/h3rald/min/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "017178f88bd923862b64f316098772c1912f2eef9304c1164ba257829f1bbfc2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "df3efb13f502be8765eb32f92c34e839774a9c528eee4cf28e95c745c70df742"
    sha256 cellar: :any,                 arm64_sequoia: "55abfc756fcd03084ea6cecc4f55f694127244be085a40fb475c8ea313c1b1ff"
    sha256 cellar: :any,                 arm64_sonoma:  "dfce5c1fe83a37626f59fb7f55560d7e6127c29a110602a0c0e2e8ff2469720c"
    sha256 cellar: :any,                 arm64_ventura: "55dd93aee4c6e5b332fb6ef5068f9076ee0188c682aac21f5e3cbc24ee8a263f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c14a84fc2c375ab64eef59cea18373fb47a154d5946e24c1b32dff772470b99d"
    sha256 cellar: :any_skip_relocation, ventura:       "1d103d8fdb4f5d04ac85c30966ec14ce719822cc287aff6bda29d2e7944493c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fec39dc5874993f43231ceb8a90d0f774a7956906e4549335d21a4b43078d64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d41319d9cf4c586dae36e4eed94e93cfc70969a977c592f7d819d9d6d420a7d"
  end

  depends_on "nim"
  depends_on "openssl@3"
  depends_on "pcre"

  def install
    system "nimble", "build", '--passL:"-lpcre -lssl -lcrypto"'
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
