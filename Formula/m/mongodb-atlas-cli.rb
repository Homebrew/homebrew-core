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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eef92aff70cfea74c65565ff740916fc0ed595ac449a34f609e9fdc62832d367"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b674d50658fef055f96a19aafeaffe826d6a76d27178c40656d7706fcb6a2aee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa1476f3875f8a9b575cb2655d8ddd6e5dd2dc8425f6ff8e65336cf240834dd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "56b779f6a48be5a152e8ae9064f3fdd7c28f55d6c0e1495ef74eaefb13eb9910"
    sha256 cellar: :any,                 x86_64_linux:      "9520102c28f932c8ac46bc6d1ddcbed8eac1c75028d58d84a084937c3e4b11ac"
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
