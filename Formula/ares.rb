class Ares < Formula
  desc "Automated decoding of encrypted text"
  homepage "https://github.com/bee-san/Ares"
  url "https://github.com/bee-san/Ares/archive/refs/tags/0.9.0.tar.gz"
  sha256 "433d50f06480547c9f6d1351a116675245a624e99eddecfe4f083442168993ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4056a2c9a7470faba848339a362f598ceafbbbb43537c788854c0f40ba437d88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1f19c2e6091c08588ee99c39206adec69b40598c6110396498efea96d2b160d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acfa1324688095b8924adff1dc943c6a51ac5453f0c6fc3de95c2571e1203ad7"
    sha256 cellar: :any_skip_relocation, ventura:        "14af97eb980e316c5c650a9b1c088be62ca101345a71995c12d06ca2b84cd6ad"
    sha256 cellar: :any_skip_relocation, monterey:       "82908eeaf4e53a25214203c5aa5c3ea035ba0a16e0589bc014ee241659549a54"
    sha256 cellar: :any_skip_relocation, big_sur:        "677396f10bad5eedf674b6d34171da7b244ea211a392dec1f7e130a30ba10829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ceeacf4ea0417342944f85f1c9ad157a850fcd3f7fb81a29e8bdc5c8e58b4da9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input_string = "U0dWc2JHOGdabkp2YlNCSWIyMWxZbkpsZHc9PQ=="
    expected_text = "Hello from Homebrew"
    assert_includes shell_output("#{bin}/ares -d -t #{input_string}"), expected_text
  end
end
