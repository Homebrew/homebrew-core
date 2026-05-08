class ConfigFileValidator < Formula
  desc "CLI tool to validate different configuration file types"
  homepage "https://boeing.github.io/config-file-validator/"
  url "https://github.com/Boeing/config-file-validator/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "b1e2082d97f15446cbbd5de47c4614994aba862061acb89f2d49499d2838bfcb"
  license "Apache-2.0"
  head "https://github.com/Boeing/config-file-validator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17386a1482d4a7bed23a281f0a4d883a849ff2fbee6b72512f4bf77300ae3cfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17386a1482d4a7bed23a281f0a4d883a849ff2fbee6b72512f4bf77300ae3cfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17386a1482d4a7bed23a281f0a4d883a849ff2fbee6b72512f4bf77300ae3cfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "133d5bf3b29150d9d18837036205f3d809d6af62e8e7df3af9823fd61e7ef00d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13adf752054f0b868ec3fb7a53776db10fc16947219dab4af5d9bc68abbf8a9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b2c7952f1780ee48b06ad4bcd2182352ded459216efffefbc81321b4666db1a"
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
