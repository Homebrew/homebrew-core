class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "dfb1fe557f74b13ccb307f22d5bebbbe50433c225cef317a8ec761c7f7ea37b0"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "162ac301c9dbd984bf2e6d9b70d12fa4dc3c925c62eced93f7a46569075198bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "162ac301c9dbd984bf2e6d9b70d12fa4dc3c925c62eced93f7a46569075198bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "162ac301c9dbd984bf2e6d9b70d12fa4dc3c925c62eced93f7a46569075198bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "84d97ed2be57732f4453e95b0d2aa03901a17531f5188b2dcb79194250db17a9"
    sha256 cellar: :any_skip_relocation, ventura:       "84d97ed2be57732f4453e95b0d2aa03901a17531f5188b2dcb79194250db17a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bf2ee72203526349f54f6afca6be6fc393d568e4cc51de1a234437be8ee6eb8"
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
    system bin/"conftest", "verify", "-p", "test.rego"
  end
end
