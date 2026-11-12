class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/v1.60.0.tar.gz"
  sha256 "99a0b1d65cb30f6ee095c7a46dce70c41546e324084285f1b5cb47bd5074b60e"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "13967e412157e49d5e2f9b2c4d9a5f8475b774f500032ee064eeb3a3895c8d90"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6efd6b90cce2f14d4984f2d3944e747f5d9540028e9b3b6f292e5b625ca095f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2545702e502c27d5b9dd269090c0e8291fa4e6021c58e169d5c7e2cd3b46439f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1eb9af74772c85d19ec108c7b1fa3bef958d84263c67f566395cc093b0675aa6"
    sha256 cellar: :any,                 x86_64_linux:      "659422b715ca8e988105a0db73198a1cabfe18fce8ab79f7fc78fdedcb55dccf"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  # `test do` block expects an `unauthorized` error from cloud.mongodb.com
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
