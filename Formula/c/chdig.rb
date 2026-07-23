class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://github.com/azat/chdig/archive/refs/tags/v26.7.1.tar.gz"
  sha256 "29b6adddc9417f244568285e635626375ce927b351e4d31546108cd24565a34a"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b4ff90f44e7c1d37b841561790dffcd41eacb0eb266af6723f40deae8c14185"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "135f61f0e18b7424310b2ae79336d240443c754fcaa923b911f5d0fd00c61ca9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b998c9bcc72e249ac0cf8a2f892dea11e5253de33952ca6f932e333a310fb53"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9e47467eaed327e61b231df05c08f27061752b20962dc49a4150317c61b1af3"
    sha256 cellar: :any,                 arm64_linux:   "5fabb80f786f43e876d7159a95e957d8578df6728daec77747b9a3ec30053a28"
    sha256 cellar: :any,                 x86_64_linux:  "0840fe9991f04d1903017ed0b1d1dc3da145ec4d9cfc784bf811d9b95a72cf6b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"chdig", "--completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chdig --version")

    output = shell_output("#{bin}/chdig --url 255.255.255.255 dictionaries 2>&1", 1)
    assert_match "Error: Cannot connect to ClickHouse", output
  end
end
