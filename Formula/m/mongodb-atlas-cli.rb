class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.58.3.tar.gz"
  sha256 "6674f810d7d66d4d6e61474f43d54e984a1ed6340d91a1e4a1bf2ba26884e9c0"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a681e7c611494e1e0de6c5ed2ce304313b0170dfeae654cec9a8cc9131b9835a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "80cc4d027cf8cf6e5e23dc7de23b055fddb6515dde56a742e390c602e40f0574"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "71d2beec32f3bd01d16663484ea2a251f4b6c440dfb350639d9ff9cc0608da4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "fc089782f01c9bcc84ff40f10ca2974f151848ebae6387a50d5e2b5cf5a61b16"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b51c53aa1acc69eb2eae46b31f4521ee8a7aaae06b491945dc9e3daba4048f67"
    sha256 cellar: :any,                 x86_64_linux:      "3d5d5a49ee91cb8d96737786c4774812ad474bf3b91b2863e49e98c13ecab6cd"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  # `test do` block expects an `unauthorized` error from cloud.mongodb.com
  deny_network_access! [:build, :postinstall]

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
