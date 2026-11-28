class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/v1.60.1.tar.gz"
  sha256 "f5160d1f60fad4aeb60e87baadf56d4f811706e60b6251a8e4f94b1913eb63a1"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "366940abc1d067752952fc5651af586a2a58a4c0a8807e9bd62425b8ce550930"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "143bc47b8f9666a9a1fdbd4b4d5a49c7fdf7d7c1eaca1194d9d75c107dce41c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c4c14f29322864fbb00f4d99e0f09c36863ff6305701c401703f6e366822096e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "977b8a8440fbdb84749dc74e93190e761a219f83b7cf056d81f0721d897600ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d68f792a4044850cdfd7aa99cd4c85c7eafc0a41df4014e0b0760e83cc9987d3"
    sha256 cellar: :any,                 x86_64_linux:      "0f4e03cd36a94e32ab47b3340a6b0eaabec61dfb3f2e4ec1e5ae53188facf321"
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
