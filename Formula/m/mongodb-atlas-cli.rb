class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.53.2.tar.gz"
  sha256 "decbbad9e9c9513fef64edf6cb6394044700badce6827912d3b3ebfb9230031e"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6de58b616cef403fb54bca971152d183f08843b282726ac13e566db1222b77e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d4eb7ab5ec4418c6f00c30284727be54b7e4a309df57c4d0c947067fd1ba2fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b1cc2a00ca6e1164c03a7f54c675cbc652d3be61a5d8c955c57b37ff175cf68"
    sha256 cellar: :any_skip_relocation, sonoma:        "a583b3ae74001f5213880dfe0b0b980e2f7ccd8143256e08aee8b12cc015ad0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ae3423a535c8784d57435e3fbf3800213ddc6feb9450c8f06b35c6ce3b28af4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c9caf27ddc26422b4005f973bfaa4e103e368edb716a1ad3cfd509465303150"
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
