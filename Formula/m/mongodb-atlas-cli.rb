class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.53.1.tar.gz"
  sha256 "e8a7ec78e5c8b3d05045dfc4dbf864f5deb6c53ccda5a87c8ed05bdcaa74eb75"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f93b1b4cddd5e03dc19a6a3acca071dd942f68bd3b41a8ab97e007f8987cdd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a667898641e4f9da40dd19af0c5fb840a48bfc9d8821c628adbd8989a288328b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f20e768ef58b5b2edefa0a8a98ff6873493ede875fe85c24f536d0be1ca5be3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd78e507fe43f7520dc996cdcbc96f6a888ba6d5675273aef991fc9ddca3fd44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84397c0ddcfae80c85a2ad130d7ab3284fa8f51d0ab457a1fc3849262aaad7a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d2b278d0a81151aa2affd154cac9a46780b6a514162631e06fcd8a08e1cc20e"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  def install
    ENV["ATLAS_VERSION"] = version.to_s
    ENV["MCLI_GIT_SHA"] = "homebrew-release"

    system "make", "build"
    bin.install "bin/atlas"

    generate_completions_from_executable(bin/"atlas", shell_parameter_format: :cobra)
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: unauthorized", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end
