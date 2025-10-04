class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.48.0.tar.gz"
  sha256 "f8168ab3bf0670b52ed0bd630a6b5b1f6f52bfbf46ff0cd7d82f820e630a346c"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adb5740095547661d3df98ffa86f06dd7110fabf1c7061fe70a8ea7f61b00864"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "497ecd94bc7846066bff22463c07e76b4f56b5fd0bea99e179cb3961d9cea9c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "732fda2d6f60f44630f0cf01286c9f126c784195c4e646571731f6c43371e424"
    sha256 cellar: :any_skip_relocation, sonoma:        "12977e73300af1a437a3f3e6935236bb02098feffbebfa60293742df22840656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d19f062c68f78a5a9687056eddac44dd6581e1401850bba66b0a82e126e09990"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  def install
    ENV["ATLAS_VERSION"] = version.to_s
    ENV["MCLI_GIT_SHA"] = "homebrew-release"

    system "make", "build"
    bin.install "bin/atlas"

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: unauthorized", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end
