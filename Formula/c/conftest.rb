class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.45.0.tar.gz"
  sha256 "e8fb618f86ba68ee687f66e792c52e06dbe45bb4f48df32260ac3f4ec94cf4bd"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "168af436f7b1837517be4725aa9137b301b67c287ffb6a5343930df1446a1f28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "693ca9b0f58b0eade3f18dd7f1657364caf452ce13e003ec3d2387d36b4a3dd9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eadb5f1867661595cca49154ca4b2c2c578818c00e3f5b3cd02d227bacfa661d"
    sha256 cellar: :any_skip_relocation, ventura:        "778e3003be102dddaec16edd2b8b61a80f228df628f7d493c42fa79a0bdcda06"
    sha256 cellar: :any_skip_relocation, monterey:       "bb54e19b0dfd32089702510107bc0b8b7b0dcbc0d1573b9aa78f6cc08b924692"
    sha256 cellar: :any_skip_relocation, big_sur:        "2dfee33847f5a8a134a856b2433f77f98061b99175fba0de79f16b2a4a7f252c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e73a69bfce52b0dbd053d0424bcc25f651504958c1e9333c839c6a446088b69"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/open-policy-agent/conftest/internal/commands.version=#{version}")

    generate_completions_from_executable(bin/"conftest", "completion")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system "#{bin}/conftest", "verify", "-p", "test.rego"
  end
end
