class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.11.tar.gz"
  sha256 "5ee95309840140713b82ef1dadad91372734dc2fd2bd9d3a02d85f83c8d790eb"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f01a85bb047d967ed007cde3daac4e75ee6b8d04be498e11cad6016140c547e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69850a4e593a7775bec19527c7f5a963edf73b8555f331e23fa08621ebeafb99"
    sha256 cellar: :any_skip_relocation, monterey:       "3c4035b7bd8bb37f3488e235d917658cc63c76d00a0c78345aa9c886971dbe45"
    sha256 cellar: :any_skip_relocation, big_sur:        "9edd09f0997c8985fda2d10d5bae5c6166f0d6c2a0d79b2bd078f195f70cb44a"
    sha256 cellar: :any_skip_relocation, catalina:       "cefce92ed7ace51a984b1c4fe90c0269fad4a39abf9f381e1164e6d4a1535ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0a2e5250516ea13bb74c9379447ffe1871999e7f4ad318fbcd01d8bdca4fb4c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
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
