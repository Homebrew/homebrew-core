class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://github.com/azat/chdig/archive/refs/tags/v26.10.1.tar.gz"
  sha256 "a6c63271cec839d862cab09ef46feb062e6a41b18b826984c92a53b537db1236"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3ac55c87f7a55afef1845831037b0c4211b8e85bdaab6ec7166a6fdde43fa3be"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "743f29415854638dfcd641907de6c0fbbd51cf1fb4779ecfc2be74ea0eaa9bb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "463487c246eb9169ee202ee96c5b6c259cdffb987692feb3e80c2bbc50464bb5"
    sha256 cellar: :any,                 arm64_linux:       "ace11384aa346dda2119eb3cf7a1c80bfefde90e4aa8ca878d3302570e3d165b"
    sha256 cellar: :any,                 x86_64_linux:      "922bb43e421e0139522730a61e0d0c990bedc8eb698258669022fcdb7b4df95a"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
