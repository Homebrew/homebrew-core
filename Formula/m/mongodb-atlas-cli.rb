class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.57.0.tar.gz"
  sha256 "a9bc0bb01dbf6ef5d72a79569f0c6026a0b4883dc55aa712bfc99b1e7591bedb"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "387526eb70b3058989d57a6533aab417ce96b67e7fdd0dce61b57ba3b374760c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97ae0431bcf29856cb07ee1da8af42492eccf4ec90781999fdc20b557528057f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df2d2fcdfe7740495aeaf86047c5211873611a94130c6b7a0ce4856f70b5676c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff16c3d784198b9c72dc4b90fb99c112ea7ae7dd34e25c23216028c7d686be01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0f35b4503f42d64a52615003b7d83d7060133849d70f46495ec9db2f3983268"
    sha256 cellar: :any,                 x86_64_linux:  "1e1dad10c598ab4d92a04fe50c50414db90295adc1ba08f1ef42cdff366f68cb"
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
