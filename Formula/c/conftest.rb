class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "91bba4a58039c8da1e318f927b42a6c227554623268e49b5c955078a3eb64d82"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f41dbda68a6932878f6b26a976256eb415b179f552fd81e10966b0ee39c1bb9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f41dbda68a6932878f6b26a976256eb415b179f552fd81e10966b0ee39c1bb9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f41dbda68a6932878f6b26a976256eb415b179f552fd81e10966b0ee39c1bb9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "20074a465ce01f069909f6953447dd05a1d1ca335dd8fc03eec005fdf669a52e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91d89282e5bc2ee6cb118e355bd420c3b7e381cd26badb2c42ddcd4e51cbacfd"
    sha256 cellar: :any,                 x86_64_linux:  "e7846f4cf2ece44da7ac537953b27ed639932836191b1bb522211fae3bb4dd77"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/open-policy-agent/conftest/internal/commands.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"conftest", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system bin/"conftest", "verify", "-p", "test.rego"
  end
end
