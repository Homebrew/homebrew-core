class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.55.0.tar.gz"
  sha256 "298addc632198326489a59a27caa61f08160690f6da35e2e133c5a4dfe8118bd"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "488a5715cfab3348ab990773a70e5bdfacab90d565661771587fcb0686b4e01d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4b91c7e5503da41b92c8659f902d0068c5a0aaca7667267cbda743bd6fa08e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75d43663f6d8e067053d66846bbceba285ede556a1b8f11a591f560763cc62ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ede747b55c1c726376c30bde71a042b1cf4ef15a348346f619d5e11e5852ebd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3724216431dc6f4ccc1d1223c719b5de28929c228625fc666661dcd7ca9a2d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db3b57f0b29c59d31a724cb92b86b949fba52f5e54d09f30f320cee69da02794"
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
