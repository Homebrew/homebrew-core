class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.14.tar.gz"
  sha256 "34c9a0fda9c635706a2b82dcaf11f6536cba6f24c6ff403fdf377e323f8f6272"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b45c981456f0bc10e3da974cbcf095aa9946d7b49b7fdacab3110f68195aa67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96a5c1a2ca256e3a8bda14c8cdd75ff90aecbb321a89798f65abd91add866a31"
    sha256 cellar: :any_skip_relocation, monterey:       "43ef795c42806fc865b79a51fc2f5a9f03381d2f54fd7654cf04d65c110b823c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4413cede34a6722532a4ea8a9af264476e8d729584f31c7554ee4d398f3a4c14"
    sha256 cellar: :any_skip_relocation, catalina:       "9f4370ceeed4c93f2cd9341ba4cd7cf4d0646b241d8a90b40c1f473cb4bd23a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63973046a2b6176901557becad91daec0824ec5856cde0adce5419ef5b991eaa"
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
