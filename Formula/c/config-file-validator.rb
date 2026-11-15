class ConfigFileValidator < Formula
  desc "CLI tool to validate different configuration file types"
  homepage "https://boeing.github.io/config-file-validator/"
  url "https://github.com/Boeing/config-file-validator/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "987931434d0fe2b5bdc4fc4c630a7c2f2f05ca51d1245f5c269c139a9e9e296c"
  license "Apache-2.0"
  head "https://github.com/Boeing/config-file-validator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b386849468d88e8d2ab4290fa305c52b032e742a6275d11cc8b0880b100e7116"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b386849468d88e8d2ab4290fa305c52b032e742a6275d11cc8b0880b100e7116"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b386849468d88e8d2ab4290fa305c52b032e742a6275d11cc8b0880b100e7116"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "53961f9afc540649dccbd928861034cafcbb82ca252516ec223fc83b996edba0"
    sha256 cellar: :any,                 x86_64_linux:      "1b47958e640c80cea9b42ce8670d5005f53e5b5e9e67217cc5a1edc92724fcf9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/Boeing/config-file-validator/v3.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"cfv"), "./cmd/cfv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cfv -version")

    test_file = testpath/"test.json"
    test_file.write <<~JSON
      { "valid": "json" }
    JSON
    assert_match "✓ #{test_file}", shell_output("#{bin}/cfv #{test_file}")
  end
end
