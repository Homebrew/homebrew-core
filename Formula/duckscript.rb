class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.15.tar.gz"
  sha256 "ff9088b3d288ea7dc7cc4f240e8b844a4d32237304dffd59c76ffa5ed6f38196"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a70fa8674ac556a2818039dc5d04dd009912d146e4ce75a9d6d040a21a5f7738"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7b924b953d5e6051000bd9f5468c8596312e8703aa841d3c7e6fc9210e965c7"
    sha256 cellar: :any_skip_relocation, monterey:       "bab14e845c401a54a349b8066f0d17facff32f0b8a8b35a7b390bb2cc0806751"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce3af414a15f43f5138a624f732505866ad133b20b398bb57963778816deea83"
    sha256 cellar: :any_skip_relocation, catalina:       "ad416566cc2488d0983336498b7aca59a0a6d4d71fbf352540628faf0ad88dca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f484a0a45bbdc073c9ebd81fc5e54b5dd770683fb8e59b277069936bf5f4d2c"
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
