class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.18.0.tar.gz"
  sha256 "5ad5b7a3a68e6c52aec06c62ca12408291be4d987ac6f7367c7ec47a9a5c5fba"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f81488cf11d996653ea6a3e302d7478532010779340cfdbc61be1ae77dfeb8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "123d0f4b389378ab7bbebcca1cc8be88def4e57bef135a8b63512da7a3f0651d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f844a2f38acf84a496a03011f88daaadfc447ffa4645330cc0af1d3f4c704f3"
    sha256 cellar: :any_skip_relocation, ventura:       "9783a665062a11518b39ef6fe6ad5f17e88f95670360b275e2f8dff34898b08b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0958fdb574f60ff2e0d6ca1a4cb59a2d3f42b60fa67ccde44c58fcea3680e2f0"
  end

  depends_on "go" => :build
  depends_on "mongosh"
  depends_on "podman"

  conflicts_with "nim", because: "both install `atlas` executable"

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
