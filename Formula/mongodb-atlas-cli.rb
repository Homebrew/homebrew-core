class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/mongocli/v1.31.0.tar.gz"
  sha256 "2967a73d489b015172df44873ac327f844a63eb7db87ac1d7e82c78a181957c1"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5e3fef6042477316e6648cd3853107ffcf5e2a92a7000250897dcf568c2791d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d06103e192d008aaaa78f229c024581adfebe57281507c0cdc9b783dd8ab1fc1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b8ab4e2ddf474c14f1cb1d20d4a7f63c98f3f69d360796b451b60cb46d27fa5"
    sha256 cellar: :any_skip_relocation, ventura:        "56001c1f1ff030f0e4df0f2e20ea01905dca1bfaa433ec62920420663116a1fe"
    sha256 cellar: :any_skip_relocation, monterey:       "fb9a1808d8a1b345b4a6b6fca46ea5c67311ff37d002e2d6e4f146522183e259"
    sha256 cellar: :any_skip_relocation, big_sur:        "401a0e0842c2832d1dfe2425417a2be9428fcd6de8466ba7de205325df024e77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d64cfe587c41174bee9f1b8fd98618d2b6f09aa24b58f233d14720e65ebccd0d"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  def install
    with_env(
      ATLAS_VERSION: version.to_s,
      MCLI_GIT_SHA:  "homebrew-release",
    ) do
      system "make", "build-atlascli"
    end
    bin.install "bin/atlas"

    generate_completions_from_executable(bin/"atlas", "completion", base_name: "atlas")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end
