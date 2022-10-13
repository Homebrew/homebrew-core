class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.15.tar.gz"
  sha256 "ff9088b3d288ea7dc7cc4f240e8b844a4d32237304dffd59c76ffa5ed6f38196"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e5d0d0172f41010a3fe774ac84e5b4244fd7c6d769151e9245b92210e4e6dc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d89dadfd86be4b23074a7ca0dd27a7fb0536527b35da7750f97fc677d88dd835"
    sha256 cellar: :any_skip_relocation, monterey:       "1f27bd3f784d98d823c671372639b145735b7c53233c39a877e3a5055ef0be00"
    sha256 cellar: :any_skip_relocation, big_sur:        "764d72531b01577f9bd099015f63b962f9952cf1b2bed65f65d6189aa7fbe0dc"
    sha256 cellar: :any_skip_relocation, catalina:       "d1ac23ca002a990cd17744d761dea89baf4e25ed7c99a0575c23ac1d09ae1b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b82a79de3fac6ca45d18de0e4b4b4ef21f6413075f5a6f5dbb280f634a61025c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", "--features", "tls-native", *std_cargo_args(path: "duckscript_cli")
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
