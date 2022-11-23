class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.16.tar.gz"
  sha256 "d5c8aa607986e542746df5b4e68a20b77f32fcbf4d34faea718b09a89b22407e"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f9b704892694dd7f25c1fd9ec6339bfaed0c9b037f2b0bd61f02df876402b72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb10344b0cb06968116c020655e911a25bbb5932e459d96987db3efecab863f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed360751a3c2d4f18e814ded82edc7979cf8e04f08c6b1fa834f9decc1e394d6"
    sha256 cellar: :any_skip_relocation, ventura:        "0b30683004a16a49afa83c210d063bc5922b4a21771bf98eccb61c9080d6ec1e"
    sha256 cellar: :any_skip_relocation, monterey:       "74aec71e559bd061699b7eff0db941e2fc0e419a9c94a0910a44da9752c136e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "712af7fa480b36a9ee497aefbe712160866cb9bb6434e6cbea822ab2dd6e8e15"
    sha256 cellar: :any_skip_relocation, catalina:       "f96302fc40c976bfe6a893da8f5509c7b000ccb1e74c2fd02c879a5a2d1317df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "632ba8ed573c822940f8f6c20baa4139cded4a2447a8f28cc2bb77a2d718d65d"
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
