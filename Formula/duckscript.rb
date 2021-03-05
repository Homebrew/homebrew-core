class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.7.4.tar.gz"
  sha256 "5ed549a48e88c281df80018d432edf59173a207c9133041213ff141fd39b587d"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b97b5b6fb82b2c263a6941cb36f806ab8c836543a6e9a5cf1c18e8c118e0d23b"
    sha256 cellar: :any_skip_relocation, big_sur:       "f63b44bde7deb92409b158f1705e2d5612630d04bc1e7f13be738ba362f300eb"
    sha256 cellar: :any_skip_relocation, catalina:      "054b0ecf57c94d4c62366f5ff8f0a5ce49ff345df7e5d297cf93c5d207b3454f"
    sha256 cellar: :any_skip_relocation, mojave:        "4d9008c3a66da1bf6301cd3013fa80119614df8b9442624a5072c1f5f2162dab"
  end

  depends_on "rust" => :build

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
