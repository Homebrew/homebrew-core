class Jless < Formula
  desc "Command-line pager for JSON data"
  homepage "https://jless.io/"
  url "https://github.com/PaulJuliusMartinez/jless/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "3f1168c9b2432f7f4fa9dd3c31b55e371ef9d6f822dc98a8cdce5318a112bf2d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c4cb7a1e0c7679b0938b0ba541f0999edaa38f5ea7ae184f0f742b4308e1523"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e6fec31ab0e4bd02adc3ecad370d078ef5eb29346e38d1513133cb895614f38"
    sha256 cellar: :any_skip_relocation, monterey:       "6b1d51fbd3bbf48c03b3c745b51b76efcfbb5a6c499f0a781199e85ef665d5bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4de98153100df7d2c71843ce981919d322a56521eaf4a67927a7338ee2c650e"
    sha256 cellar: :any_skip_relocation, catalina:       "caa1ee82da08f712bc9aec31add0b4842cef0027f2fd1ad976c22063e439eddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28573ca787ec25727eb3b1b9ad08f6b90d66c899a4c28eee1ec86c0331b6ade5"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write('{"hello": "world"}')
    res, process = Open3.capture2("#{bin}/jless example.json")
    assert_equal("world", JSON.parse(res)["hello"])
    assert_equal(process.exitstatus, 0)
  end
end
