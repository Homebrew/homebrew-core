class ConfigFileValidator < Formula
  desc "CLI tool to validate different configuration file types"
  homepage "https://boeing.github.io/config-file-validator/"
  url "https://github.com/Boeing/config-file-validator/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "43d2a3000424cb1e4eeb38c7ddd444930140f2ae106ac1ac66ef7b2f9451d631"
  license "Apache-2.0"
  head "https://github.com/Boeing/config-file-validator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a750309e0c8f2186c579c45cf6d5fb34f3350827727bfc74d7d6f9655f894de4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a750309e0c8f2186c579c45cf6d5fb34f3350827727bfc74d7d6f9655f894de4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a750309e0c8f2186c579c45cf6d5fb34f3350827727bfc74d7d6f9655f894de4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f60bf413121ce1a00314d5e1b4b012318d14a1c9753d1ac16030165ea0d8de2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a525a5b218f00a8969fb43abdd75130bfb106a300ffee1db070ecad3b8ecfa45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db4130366a742fb8ae1e27619989a1c14d3e2fb778fb492d6d6c57d99b93ad04"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Boeing/config-file-validator/v2.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"validator"), "./cmd/validator"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/validator -version")

    test_file = testpath/"test.json"
    test_file.write('{"valid": "json"}')
    assert_match "✓ #{test_file}", shell_output("#{bin}/validator #{test_file}")
  end
end
