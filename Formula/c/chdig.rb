class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://github.com/azat/chdig/archive/refs/tags/v25.6.2.tar.gz"
  sha256 "252fca193d71ca26f00d9c10e6755a060e813168a6faf8067fb2366abcdd5e3c"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d64866eff14e29e71aac9253e4bdb693c575af88050fd846c1561f4cdd7f809"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cb005ca4570f029618123157c0a37ebda4cdf5fc3efe1c0c722e1f7b00a6adc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82d9a984546d5bc4603ad5c038f13168c29de1cd8557f751cccafc88a4f39b66"
    sha256 cellar: :any_skip_relocation, sonoma:        "82dab0e7d493e406ee04b58d9d26a6e0a848c8e50ea6a5f9e83e8c6feed2076f"
    sha256 cellar: :any_skip_relocation, ventura:       "b36a49220fc530cf0b139beb7e100933db25255504fe04c7d51487414be16267"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "512008a7e52db8d41b2f6cc7be9128fe638e88e297eafbe50d0d48069da07163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "510551e8e4f0543b36ee36d143ac7c764e8862b21fe3787fb32a7c06de1ec235"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"chdig", "--completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chdig --version")

    # failed with Linux CI, `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}/chdig --url 255.255.255.255 dictionaries 2>&1", 1)
    assert_match "Error: Cannot connect to ClickHouse", output
  end
end
