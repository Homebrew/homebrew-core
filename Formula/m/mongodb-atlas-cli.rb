class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.18.0.tar.gz"
  sha256 "5ad5b7a3a68e6c52aec06c62ca12408291be4d987ac6f7367c7ec47a9a5c5fba"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f419cf9f38412b62f31ff46f54a576d917741a846ffb1dd3311bd44fce497c70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa5fa8f03ad73120a7016352e388cc03010ce65c5063cbe7fd64ff7e266395ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8717af17bcba5760879acb913830f0f9f31f3681eb1cc0fc787c3ddde33af69"
    sha256 cellar: :any_skip_relocation, sonoma:         "49fc52eba8aaa70f98c5ca1ff40ba9322d6b058dada2207b6da94fa57d53b942"
    sha256 cellar: :any_skip_relocation, ventura:        "27c95b7d1551fea907c3689a3bdc0cadce5bafc8e9a43c9f20fba0dccedda5fa"
    sha256 cellar: :any_skip_relocation, monterey:       "351b489ae8fb42c2f43a3a82054138aaf77e11d06cddbc92e754d6cd6746a7ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8aaa8b9c994be000f61288d7fc6e10b32000c37e429a792bc697ff48fd20ad9"
  end

  depends_on "go" => :build
  depends_on "mongosh"
  depends_on "podman"

  conflicts_with "nim", because: "both install `atlas` executable"

  def install
    ENV["ATLAS_VERSION"] = version.to_s
    ENV["MCLI_GIT_SHA"] = "homebrew-release"

    system "make", "build"
    bin.install "bin/atlas"

    generate_completions_from_executable(bin/"atlas", "completion", base_name: "atlas")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end
