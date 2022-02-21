class Jless < Formula
  desc "Command-line pager for JSON data"
  homepage "https://pauljuliusmartinez.github.io/"
  url "https://github.com/PaulJuliusMartinez/jless/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "5d776cb6488743ccdaeeffb4bfc54d84862028170cee852a8bb5c156526ed263"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57c907a913f3ff76f5d512c2e9ae8a2fe04274145d1229b4061d47f42e705c58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d98ace9bbd3e9e9f6bed4cf88f14d64da1be7e2519228526cfc3f76a0016cc4"
    sha256 cellar: :any_skip_relocation, monterey:       "a54c215233d330c415682c03859e8565fcc7be354091f02d56bc24971745d62a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c8a0fb4b7d42da4feab7a818a687cc5dc03d7892d8db7f80a91187780551f46"
    sha256 cellar: :any_skip_relocation, catalina:       "fab76051b8085b8b705f480fd9fa88225a2b11559b53f40222fa119e272dffb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "760ddb38ad6a95b70aae4e0a77c3a6dc1f593f45977a98b58a7a8eff8146cf17"
  end

  depends_on "rust" => :build

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
