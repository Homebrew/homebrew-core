class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.1.3.tar.gz"
  sha256 "00f264f6f34efcd018a3301f75a74085ca6ae6eb961056b91303a3f596921cde"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3656a2fdde33935d3c4ca1b624fa2e1235375a5f55e4206b964399917bb27aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9496c10d011eb76a4d2b10d81d5be422b30ba08c203e775c9cf8fac53771a7ec"
    sha256 cellar: :any_skip_relocation, monterey:       "f014b5fe2e6af3d5fa7b91135684e21e11f358f8fb6adff5db977a99ea990688"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cd0d130fff644ff3a7994ba7da6ad472cf2764abc14cb7bdca08725709eed77"
    sha256 cellar: :any_skip_relocation, catalina:       "69d29c3ff5ae26bc715002d53bcba5c7c12d7c6d9d554695e35709f6e9741147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eee1da35ce684a2d6fdb6fcc2962f3c63f3d53cf68e756f25ce1c2f8264526f3"
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
