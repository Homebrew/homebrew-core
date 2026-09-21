class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://www.mongodb.com/docs/mongocli/current/"
  url "https://github.com/mongodb/mongodb-cli/archive/refs/tags/mongocli/v2.0.8.tar.gz"
  sha256 "3c12529959e459d990b5e1670e471f7137f95b294503b2c620eda17aab4112bb"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1b2b7e1e422e0aa9cd2c23c354e46ad7a28048bc03b0daeb549a967fd7ab084c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b16b26ee90526e19625813739c3895004666ca80026a7d011336851ea7777104"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "71973858864a6fd36075881f81fc3ebf572471b9d2ed42d1e3586c70febc736a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b5b7d331153ecbc3e5327817c9737850ffb17efae5f1223639c2a177db898fb0"
    sha256 cellar: :any,                 x86_64_linux:      "81f3365084cab0cfe7d235daa2f776c023d21d4c40f720cefa0b7e9a39a1eb84"
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
