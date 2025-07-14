class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.46.2.tar.gz"
  sha256 "623b431b196368d720c79130f879f4f9c223c7fb59e387ef4dcaf6af0ec15d6f"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17558ab226a22b8b27709b2ecca3aeaaf96e13ac71559e14a0ba72f714071e52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce3f870be5d6f3004934046e41f70baabdab432cf3923cdfecbd35d925f6f5e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94d46186b09dc9b98cbd6b7d110aee014fbb62ce785335c9d6cf1eb280d18c6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d754247210d51018ee786ba3a8c02db354be95fc9fbad8830e96fe1fa0a55b5"
    sha256 cellar: :any_skip_relocation, ventura:       "594241d73e26f79e29d1bfb7e5a3b8ad8f74ccbf82442b8c6a8f762a98060e3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e56a7e224d9666d1ca59b8a8cf96eaee966acba2296ead7816f06ea2d8db333"
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
