class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "2de0a7a7834b1b6d8861dbb7508a1bf9421ab1045dca180457a729582bf9b922"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a763e625d2c55d2f7242e682817b50b162ce7cce7cf15ac2824772441c73a88e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abe8dd8a2271d7f4775a629adcabf25552351aa0c58bcf5e96867857ef028778"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33124a6e3a9523870ee4c0de248d7eec7df4cca1f7bde2353d164448134dd617"
    sha256 cellar: :any_skip_relocation, sonoma:        "bda9ee49a399d2f0c1a7943283e3a32f6d2591a18577aea7e39f7e2b4a6109da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b273eb66447b805ae0bf53d68e31fe5fd32cc121913b4586f7babb5a8450b45e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "762faf833d913cec6c95ab31238a5752b3d33b880b5b51cf63cef685e75aab25"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/open-policy-agent/conftest/internal/commands.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"conftest", "completion")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system bin/"conftest", "verify", "-p", "test.rego"
  end
end
