class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongodb-atlas-cli"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/mongocli/v1.29.0.tar.gz"
  sha256 "72ba939d3dd65a5963196902342236ab86f4edf84b3b7ba97c633dd81037d4e6"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^mongocli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a73cbfb36b668a92a48758175194683b9da8fdfa3df5a9f4a66c5a9c3366745"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4d2688cb22d482291beed92a26a427cdd1dcec2ce72aad2978e3f65425f9360"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25f56d82d5f096b3553fcac9b96be3a3c2f0a055c10b83d00d2dabac154fda6a"
    sha256 cellar: :any_skip_relocation, ventura:        "622c73452df550859f1356b961c9e7e3bbedb75ff42b749af58172aa977a5bd0"
    sha256 cellar: :any_skip_relocation, monterey:       "3c8be35f7a4d614856f9bf85ea5099ebf73da749a0d0ab3f02aab62225a22ebc"
    sha256 cellar: :any_skip_relocation, big_sur:        "f573d7ef82cb902cb9089c046248eac9e4b0ea18ea654394a573cdec7c35c784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d41e8fc8d896a0f42d5b703449e7bf17ae314e0b5cc5702e3a315f8ba58a2271"
  end

  depends_on "go" => :build

  def install
    with_env(
      MCLI_VERSION: version.to_s,
      MCLI_GIT_SHA: "homebrew-release",
    ) do
      system "make", "build"
    end
    bin.install "bin/mongocli"

    generate_completions_from_executable(bin/"mongocli", "completion")
  end

  test do
    assert_match "mongocli version: #{version}", shell_output("#{bin}/mongocli --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/mongocli iam projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/mongocli config ls")
  end
end
