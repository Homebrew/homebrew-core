class ConfigFileValidator < Formula
  desc "CLI tool to validate different configuration file types"
  homepage "https://boeing.github.io/config-file-validator/"
  url "https://github.com/Boeing/config-file-validator/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "b484fd7ff492ddfbd05ef3e85bff6cdadc48bc75b420d8996f4e17b175ed6cd6"
  license "Apache-2.0"
  head "https://github.com/Boeing/config-file-validator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "587cc3043a81f7c7ab81a7b0ad7c9d4d66fe29236b36d6a33d51eb8059087789"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "587cc3043a81f7c7ab81a7b0ad7c9d4d66fe29236b36d6a33d51eb8059087789"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "587cc3043a81f7c7ab81a7b0ad7c9d4d66fe29236b36d6a33d51eb8059087789"
    sha256 cellar: :any_skip_relocation, sonoma:        "010fbca64692b08a6a5091dc923928ceab52028dfdf56f180cd4ca7204fd6892"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bb14af971a418d759ef3e33b78a6cbdd61d0ed80a91f6e99f98d2462ecd258a"
    sha256 cellar: :any,                 x86_64_linux:  "a8c9bc5cd0e6a80d788d98184382852284bf54de06fd428fa086bfcd68c697bf"
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
