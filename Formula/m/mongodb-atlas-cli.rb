class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.42.0.tar.gz"
  sha256 "77f29c75da38ec2f19ed5522caffdc22de0657e05fc9423793e375ddfa8c672c"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d85e730e86bfeffd8315afbaebc9d9a18d1a61269457edc1227e5336b2e9600a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1d93ae1bca4c6415f1f5ede6286d98fb4b542a1c986bfe4b5c8b478ebbc303d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da9c6af2b34d9505fded3e55d364b9b0d9a8b64100d28aed2031be050fa54414"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b7d2a12432800dc192d014e119a6e1a6048dcd1c3b42814ea87a6abb220489d"
    sha256 cellar: :any_skip_relocation, ventura:       "c308add64218597546bb16c6c01bc4664a5d83d8ad79e18e01a3f8330b05679a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8890cbc1f2cf7d3faa4f56fa066f07acf54230949582c027e63d88fd2751a78"
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
    assert_match "Error: this action requires authentication", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end
