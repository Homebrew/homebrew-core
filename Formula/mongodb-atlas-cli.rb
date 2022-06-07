class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.1.2.tar.gz"
  sha256 "b051685fdd61e6152ed914d4084046408bd2fa64acd82e16d7518af16ca65e25"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0af3606951fe106dd16186d1f8b74d9f75f9f4f06abf371651994c914d34d826"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14169fce8278aa036a28f0946a7c354e5e72185618959874fde8e5c8373cac8d"
    sha256 cellar: :any_skip_relocation, monterey:       "438d91ac88c8056ddb5599992d95afa75029edb302098d0e9c85bd310e5db595"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0762d461712d7150a6f882bb2b24e570b6dd2ebb1a1ae541c2c2c11ce4d05a2"
    sha256 cellar: :any_skip_relocation, catalina:       "c08696c435c14bee3dd2f422d282e6c1ab864bfb53b60b31020ec71880f38881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfaa59bbc049250cb6754aa2e9fb073176c8a29098b1e834b80c7eb18ac4dd38"
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

    (bash_completion/"atlas").write Utils.safe_popen_read(bin/"atlas", "completion", "bash")
    (fish_completion/"atlas.fish").write Utils.safe_popen_read(bin/"atlas", "completion", "fish")
    (zsh_completion/"_atlas").write Utils.safe_popen_read(bin/"atlas", "completion", "zsh")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end
