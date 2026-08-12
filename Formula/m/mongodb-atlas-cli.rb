class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.58.0.tar.gz"
  sha256 "f3771b1d749696cf5adc7890cf0c8e73be900ff7ea27fdfba87ed250a563074a"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35731f94ba714419cf055624dc500a720d1f7ebcae107e4bdafc5b93b8257ff5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "824f915de3bf67e6a26e07906026584feb6038af10608ae9a62d57fdcbbf292f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80b1ca10fe8712a837bf291ead5dba51fbf1819dd349f3d94962a495687382b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fc4be7a0f7fcb1879ede1fc51c325a65fa75d57975ea07f452e3b097c2cf9f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16033cb8ac3250c5aa841271ad7a7e806d227318ae8e2d097117a94583c56bda"
    sha256 cellar: :any,                 x86_64_linux:  "ecd7d9a462d3f5c020ad8e46ebe3959e11b7a0fbb4e0c7614f7988e90ef39a9d"
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
