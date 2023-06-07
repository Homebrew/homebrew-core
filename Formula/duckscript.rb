class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.19.tar.gz"
  sha256 "4a146dd124999888e9cd0648bf25e13b5b82df8fcf645368ec930d925719b54f"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6284dd3042656022237038fed6e67ae201ac3b1576d93a1f4e11c3a38b6b16f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09ee957b6d7631392259707ff809769b8fa5b7095799cd5b8c7014a45ab1c30e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd2826f6eeaffb5d9b615de01426f22d7e5fee934aa2d21a2c729194fdc80fd5"
    sha256 cellar: :any_skip_relocation, ventura:        "10952082cbf74ec67254b8f9089398f13eb9f25a96757f14d7dbc207260515f3"
    sha256 cellar: :any_skip_relocation, monterey:       "a698832f2113befdc2472df7120cc50ae48943fede19c1f77a7e472d5446d019"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5c033209821db7eb5c529c502f9675259cbc2e9605f7e75dfa9be6d5c353991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c042ff46f0006499ca910b6c9d497c00ab19267d79bfaf6ffe7d66d428d53f4c"
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
