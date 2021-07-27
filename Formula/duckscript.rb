class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.4.tar.gz"
  sha256 "f46ed47df597246cde1f15039bb315a6c50d01b9fdc3a7c69328cdbaaf142f95"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "457cb8ac4b5777a2b78b847156481f5f6932c4ced7392c0f0a2aa47035d1e893"
    sha256 cellar: :any_skip_relocation, big_sur:       "0af766d26a7972d7a1804d67d9625a465dfed139d1445da25256bee834cb9881"
    sha256 cellar: :any_skip_relocation, catalina:      "1e247fe73d4e6843332133b68d25251bb5914710db148750f977fc702a109587"
    sha256 cellar: :any_skip_relocation, mojave:        "935f8ffeac8f5173fda5eaa0fd25db04f3ff831dd814d9fe146a87854f2f5d97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53e9979faaff77c053329f061b7be4c7e4519d54aae0b7b95c4553906c6f58c2"
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
