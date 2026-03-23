class ConfigFileValidator < Formula
  desc "CLI tool to validate different configuration file types"
  homepage "https://boeing.github.io/config-file-validator/"
  url "https://github.com/Boeing/config-file-validator/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "390ae2ef18977ec72e9269c31162d411f17722d4fb309f2631c00d40dc9db11b"
  license "Apache-2.0"
  head "https://github.com/Boeing/config-file-validator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38b21f924c30cd93fc27d6223348af1ede441e2c8d5967a9b3cd0410234cdc1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38b21f924c30cd93fc27d6223348af1ede441e2c8d5967a9b3cd0410234cdc1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38b21f924c30cd93fc27d6223348af1ede441e2c8d5967a9b3cd0410234cdc1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b062eee4576605f6cf56283f29a3d0318e42bae8caa969b87e457828a6ecde7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "742cbdad4a8c1adf751f817b7915d69b7776db5560f685a2d2982ea4c1f47693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5d4fe268840d7504c55eb8defe5563727619c1775fd99844e596634982e5f3b"
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
