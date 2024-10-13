class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.29.0.tar.gz"
  sha256 "46b97645555da9f88ebec17b2857a6bc802048da518d9c964000945da546b132"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8eeddbe492fe37a3fe76a0de519084ba28379f7cbf2db4b70c6b914f7d4bb42b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26895f0af324a17d96716769d53c119526146f0025d8b0e43a105c2dd460e85e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24c541de097595609f0802853754da65e0d07a148adc1c1f3eb45d926dfda559"
    sha256 cellar: :any_skip_relocation, sonoma:        "913e2959dbba93fa87f85e080868c48e6f9cec4e7c3380ccf81aca17ed3621af"
    sha256 cellar: :any_skip_relocation, ventura:       "91a419c06f416a3fcf33a9f2836becf1d79d3ed5e27400194bd512ab49820a01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73bbaf657a2d4d7ca94de04c41d095d96ab2dfecd3ac5d292ae27095f4f56fd7"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  conflicts_with "atlas", "nim", because: "both install `atlas` executable"

  def install
    ENV["ATLAS_VERSION"] = version.to_s
    ENV["MCLI_GIT_SHA"] = "homebrew-release"

    system "make", "build"
    bin.install "bin/atlas"

    generate_completions_from_executable(bin/"atlas", "completion", base_name: "atlas")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end
