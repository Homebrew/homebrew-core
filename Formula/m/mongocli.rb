class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://www.mongodb.com/docs/mongocli/current/"
  url "https://github.com/mongodb/mongodb-cli/archive/refs/tags/v2.0.11.tar.gz"
  sha256 "1c17355ca867107e036b09c77e8ee498833337e276cedd304b6cd49390e7563b"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b56090f60056367def7597e125dfa765e598f5982251500ad5a63196e4825042"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "07fb492f7603c422165552eb4e34335f7c49ccc9d54e7e2329d5567f13fb3a6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a716563e0236c581be17a30737c5ed836c0af0b79820a555c5015c0b2a62dd01"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fc3b7072f0605a0a99d9785d6cb3ae9b0128f9b0f7fcffc19cf7f7b96a474ef9"
    sha256 cellar: :any,                 x86_64_linux:      "062f8ab909bccd2f424e8b1f1bf2cef15533a0083bbb1847d53f3b9cb6328510"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    with_env(
      MCLI_VERSION: version.to_s,
      MCLI_GIT_SHA: "homebrew-release",
    ) do
      system "make", "build"
    end
    bin.install "bin/mongocli"

    generate_completions_from_executable(bin/"mongocli", shell_parameter_format: :cobra)
  end

  test do
    assert_match "mongocli version: #{version}", shell_output("#{bin}/mongocli --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/mongocli iam projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/mongocli config ls")
  end
end
