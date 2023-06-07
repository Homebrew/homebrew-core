class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongodb-atlas-cli"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/mongocli/v1.30.0.tar.gz"
  sha256 "1d372d07e1891c519ec6637c2a57e2a636d06d279ffafc4ff87aea41ff74ab0e"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^mongocli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bf95e65b85cfe159c0630facf7fd47f846835576a41fbce94ec02ea35614043"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffc8f78f877282ec4c3df51fd87d5d32984e2188988d5b26fe869e74bf622477"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73d4c9453e8385b9d68a50a04dd05b14c789b3addc56f6cbf6c5377de05dccb6"
    sha256 cellar: :any_skip_relocation, ventura:        "acb64748e5d4a9ea59906d88090dbb17acee848ef155dee4944148c25097f33a"
    sha256 cellar: :any_skip_relocation, monterey:       "7e8419824ab54b1ee8421840813a14136305114952996b2e17d28e31d8fa2f8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d293fc6bda10d6dfc79994e8be4dec1008a2844fb59c95a01f02b09ef455f440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4799f77dc9f24166a0e27bb9fde9f99494fe45e8022ef850b64fbaa9e848259"
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
