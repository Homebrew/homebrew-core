class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://github.com/azat/chdig/archive/refs/tags/v26.3.1.tar.gz"
  sha256 "b26c11c647ed2789cbc5c87d2cdf7c601d838aee4a57dfd76b9622209dff5ade"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1490a29742ecb082617467c7337d44b2a22d6017358fa1fd841c48d68203f193"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d020a81e69b0972c4fe0d7c4040d9f5eafb23ae10b9a29bd5eccf968319d9be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3038b709b9c922640476e1f9c64ec6d23c62c8dc18e4fc04a1e30642bc01ada7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ede0202a4c5990961a406c84099cef7870af558c6f86d2f2dcd24af5a9f9efb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1471e8ae7f4596c924cd13e60ab48ed824651ed76c4e1984ba1934e7f4cfa83e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86c40d6c1aa6a5b2bd713fd0bf736fd8502be29434f89d28e2fcc48da81358bd"
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
