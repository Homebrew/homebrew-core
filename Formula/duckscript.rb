class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.2.tar.gz"
  sha256 "72d95513704aad927b858465f389136f75dbca0653813f9840707bb5691d2e1a"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3472cfd40239d31a235f9f00d665eb172589e0450518f0d36b51579afbbbee72"
    sha256 cellar: :any_skip_relocation, big_sur:       "10c582409c2b67b9a710f1d206438bcf5040b0643f041997947ff8c159104a36"
    sha256 cellar: :any_skip_relocation, catalina:      "761975f452264026e49cbe580706123acb88a33e787476644b4f76fce56da228"
    sha256 cellar: :any_skip_relocation, mojave:        "37331e2e4bec3b409c87242bd0c617c57ec01e2e0ac511d0591ca20526bc4b27"
  end

  depends_on "rust" => :build

  uses_from_macos "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "duckscript_cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"hello.ds").write <<~EOS
      out = set "Hello World"
      echo The out variable holds the value: ${out}
    EOS
    output = shell_output("#{bin}/duck hello.ds")
    assert_match "The out variable holds the value: Hello World", output
  end
end
