class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/v1.59.3.tar.gz"
  sha256 "d6e6ceba3c24f980f42bedd55fdf57cd2c66a61c1eaab500ba881f5e65a75b17"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3f0f53f6f76f1c211886892aa7ed5405a2220e32fb99b0aaaa0ea6a650f61fed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "82f2a645ce4ca2e5160d2f3ce32556a639214186a3d5566b7ad8c47865dc8adf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b20c69e09213347479e60d2e0f7635870df9ac6e0d134ce03520381691402c9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "57476862a08f33af4fdfe58161bc26d909b08b896b6ed4a70bf0dfa634f94d33"
    sha256 cellar: :any,                 x86_64_linux:      "86d1607f30079bd7c20fda2254fd0c5e89a33b92d7aa08a3fe16829d061e06c2"
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
