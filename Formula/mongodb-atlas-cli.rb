class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.7.3.tar.gz"
  sha256 "e995859c75dc42eb4083ac30da95bb7efb6e4000f5f6463b4816b8d1d1c2ee49"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a022ae84ca6f94af0f55ba9616156ed1dd94756e1721d435938e45ad50c475d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a06930885d74060439d5a6c3613bd65185c3fe6cb251fb560c9e8623a7e04d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2bb980a480db22d3bd4bd4f375d17b8b2f5ebdb8c1b90e19d58d89bc8afabbd"
    sha256 cellar: :any_skip_relocation, ventura:        "610f8a8f443fec6b395d8d5d233673b2af91b3d0062846b696a368543875c715"
    sha256 cellar: :any_skip_relocation, monterey:       "034d5ffbb78cd12e337098a96e24c89f68ac580baa9c0a003a3c8cec47101cce"
    sha256 cellar: :any_skip_relocation, big_sur:        "51add0776b99d3fb4d483a6371a13750962b48e97fce8fa7ba9afcfb5485a751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57a51ed9b49082f750b486adeada0667cec7b2eee158e50b76160405410e6aa9"
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
