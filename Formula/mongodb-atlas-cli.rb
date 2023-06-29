class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.8.0.tar.gz"
  sha256 "b1b3119dbb28862b6ea4b1a35de122a6d97b46d4e240d176880802f589c92ddd"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "895c0111a39f808b95c1ec9fbc49518698c408bad19afdef112edaadc23819cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "207677046213c6a5c3e32ea7add648153f3630fe2767faec4238edc420d99273"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00f997a62bf1b092ccbc2c5459e30995fd8b0320b389b76b813b18b5618c4851"
    sha256 cellar: :any_skip_relocation, ventura:        "7dffaddcf026d6164d55bf97ceafe93509ce13e5c63a0a604406fe3f129d0bb1"
    sha256 cellar: :any_skip_relocation, monterey:       "08e88e5926b65954f19caf79585cb44fb4bc44924717862f0b41444e05ffe074"
    sha256 cellar: :any_skip_relocation, big_sur:        "082d243ac043ec41006b747454f6bcbf0b8827649e2d6a1c3bd30f10a3ecf457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edf1c03233a938020fc56fa9c627866b540de5df57a00ba2d1eeef3fed781e92"
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
