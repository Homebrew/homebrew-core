class Ffuf < Formula
  desc "Fast web fuzzer written in Go"
  homepage "https://github.com/ffuf/ffuf"
  url "https://github.com/ffuf/ffuf/archive/v1.3.1.tar.gz"
  sha256 "136df36154f17668fb726120f0c93059f696786a34e3c2047d61efc3a065c4ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "32637322c8b42463adf6b42636cd318c9fd29e09fa8be62ee77a229e161b2a61"
    sha256 cellar: :any_skip_relocation, big_sur:       "2243d50f59109b79cd9ec47ee45b3bdb002c1f546944f2f46bbc09281ae387be"
    sha256 cellar: :any_skip_relocation, catalina:      "ab6fee3beb856c25b674e87863a29733f6da5434d3a1b93035b91d42a6ba72e3"
    sha256 cellar: :any_skip_relocation, mojave:        "3b0edfedd94bbbd378465d24a36258289c4a4b9401eddd673b64568f6da008dd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/ffuf -u https://example.org/FUZZ -w words.txt 2>&1")
    assert_match %r{:: Progress: \[5/5\].*Errors: 0 ::$}, output
  end
end
