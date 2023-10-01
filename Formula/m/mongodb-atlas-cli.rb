class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.12.0.tar.gz"
  sha256 "9c070a8b3fdc073553480e9c75d531f3e3150bc626c5bda15982617f776b8867"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d89846f5ae215963c38e7b5520f4751374ce2ea086dcb5acfec71925356feaa0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "636b8e606d69a15dbc57ccf493a154a38cb02b366b9f290f109d0fc4cf87933a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d84a9c803cab442b276772ad00f18ebd4f4a95f617c4759535e4830640e7a41b"
    sha256 cellar: :any_skip_relocation, ventura:        "20f59898d8f0393f80fe968ace0df42bfa73638ce94d3e3f025162283ff9ddb5"
    sha256 cellar: :any_skip_relocation, monterey:       "bee58d8705a42b4696b379e7f0ecf430ab9884f8bad7c48705aec88feeef5c76"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fd1d78f60c79ade2228825acc4f98fca8c4922dfbafc90cd6b64c0a16079191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3d0477213bca536d72bbbd8aabd4213d1276da6c33b6f3e1e01402a203a9a02"
  end

  depends_on "go" => :build
  depends_on "mongosh"
  depends_on "podman"

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
