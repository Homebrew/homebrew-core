class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.17.8.tar.gz"
  sha256 "2e5c189d62f2dfd4f7a593be640893925626e49ea44ad020c1b141d82849e128"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e722263a74d2bd27fb9c482ad995430d5420d313aa84d82d031d93116dde8f7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90b662b18ded864dce93a3b0ac1d2466103fe65d5d5dd4ad0fbb97a9a9061886"
    sha256 cellar: :any_skip_relocation, monterey:       "b382c184bebde54b435b972ef5e718054a06e3a14dd97a7b311c53e44de67d0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a37a855e55d914e82d62ce43133736fbaf00f1b42a98cf87cdc78c1d9e6bf06"
    sha256 cellar: :any_skip_relocation, catalina:       "bc1ebc16ec26777f6ea83b323eaf22dbab40afc4c17bdce5e537cecc1fa629b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef1f38071b02c212fc12ebf2b47b426576c986edce0165c2b66e9038f047c421"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/csvq", "--version"

    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
    EOS
    expected = <<~EOS
      a,b
      1,2
    EOS
    result = shell_output("#{bin}/csvq --format csv 'SELECT a, b FROM `test.csv`'")
    assert_equal expected, result
  end
end
