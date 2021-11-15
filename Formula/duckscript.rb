class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.9.tar.gz"
  sha256 "b26ef19d50367352af3d0ba79946838202e7418a9e53e82fbb96f05c87dd389a"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "578726ee837d0c60f2db1170fc2978013e421b3a567aa00b4179f6c964d84f32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0bee823efb9c940e3d3f379bb0752eef441624c6ed6257a633597eea688a964"
    sha256 cellar: :any_skip_relocation, monterey:       "9e3c7b047007fdcc801102b8c465ffb4044e6163a532c4be481d7b7a5a032c96"
    sha256 cellar: :any_skip_relocation, big_sur:        "95d930daa6f397152a2d684d61f2ebc4ca1f6ecabe2bf35b19263640c2f523a9"
    sha256 cellar: :any_skip_relocation, catalina:       "9cabeea061750b1016b6b1fda1151a138e447ddacd5f6d303645dba69eabd08f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d3c2cf225c1a0c35464d61d50232357c5751a98443ee068830153b6d727e6bd"
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
