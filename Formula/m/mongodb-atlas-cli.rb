class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.22.0.tar.gz"
  sha256 "1f3dc6e69f946af10e0e9df089b6526848ba6fbf25dd21a7bcc07def5a6c6d05"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d35955c85ddd83ad24df1a4c582c253fe284d0de916554eb46741628e5a14e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3933b9e9916cb73186620b3529ff8e38fc0fa0b232bb60e3a1cb7ed8e9e71fe9"
    sha256 cellar: :any_skip_relocation, sonoma:        "58fa289925d07aa57a35bcad045837f3ad4e944193cf63233efbd412a64bfc9f"
    sha256 cellar: :any_skip_relocation, ventura:       "3b9c1662d92bb458ba9a54a49ca2d8db6aaf98e8b0c3cd60dc295f475ac13f19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "515f9514abba7645dfb9696343ce409bdce90dd79873a5035c3c09728a138a89"
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
