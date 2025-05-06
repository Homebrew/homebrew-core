class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://github.com/azat/chdig/archive/refs/tags/v25.4.1.tar.gz"
  sha256 "5956bccc99f5c86eef6095ee03dde53590dd03370b06cd04348074ea223f2297"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b983bd8086b13f4c9b8656678f01a517c9a1dea76ce4c90d6c0931eab195beb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c0609d8c5284a2e7b717123e71036ec434fa4aa311c4cedf9fbec31b3d348e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b39d50f8782ae0b1c20a35254aac710c8705020189337fb98b859fca647582c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ac80eca9b7d94b9d9d1a1570fcd1494f0ac96bc1ea25dc4e6979703ad67a7fb"
    sha256 cellar: :any_skip_relocation, ventura:       "fc41f28455ef3bdd91b01f10994c1878917d8f4c8584e9442d4da8e83e4f18b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d110d05f6b19f1d5db298a2b979e67f9df13e7b276254ce49fad2e18694c99f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3a9dc13cd1c5fa758858c77cd83d169d98b382a6254cca0facc75c5e3330251"
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
