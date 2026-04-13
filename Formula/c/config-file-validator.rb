class ConfigFileValidator < Formula
  desc "CLI tool to validate different configuration file types"
  homepage "https://boeing.github.io/config-file-validator/"
  url "https://github.com/Boeing/config-file-validator/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "6bd9f868fea7dfc5e2d311dc0c574a4a3cc23d45f985361205af089720582b45"
  license "Apache-2.0"
  head "https://github.com/Boeing/config-file-validator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2baf57e82c4f4c4237ee5f4b57b4bdd56afdbb8e4699f7975aa7d738c4faefb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2baf57e82c4f4c4237ee5f4b57b4bdd56afdbb8e4699f7975aa7d738c4faefb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2baf57e82c4f4c4237ee5f4b57b4bdd56afdbb8e4699f7975aa7d738c4faefb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a309b9363faa33c4f696f7426d61b99638dbca73552886b7d9d02a93b39bfe11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0aba1e9fda8637a9df956237337485ef8dd488474d90e880048c2d966a5e123e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd79337d6ae649d0f033fb05a516223833f1839cc62531de37887f4a0c272a9f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Boeing/config-file-validator.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"validator"), "./cmd/validator"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/validator -version")

    test_file = testpath/"test.json"
    test_file.write('{"valid": "json"}')
    assert_match "✓ #{test_file}", shell_output("#{bin}/validator #{test_file}")
  end
end
