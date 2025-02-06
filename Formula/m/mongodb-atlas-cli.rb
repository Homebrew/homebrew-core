class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.37.0.tar.gz"
  sha256 "c8c5b8b9c41847bf9a1dfed8138060bab451f906be3e46b18fcbeb996d00e3e8"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98ff3e41e507ed6b9bcd11ca1da1024a5b506fd1b26d3d0b27d0d2bc56715be4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8b4510f5ffd3b87faad529e70159fe1f513e215db24670b872d0e59ad810f75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e565d47ad2cd47838b51e3da4a11e33c872b55bf97a3fc97d7e2e448d40caf40"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb51d7931b207bc040266fed738bf3f6172be121e8441959d61eba11e767d8e5"
    sha256 cellar: :any_skip_relocation, ventura:       "3d6136da62cccd13ce999497d27fe5b5881044ae3290139ac2da1ab48837fd11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a6819802df1ed7b8db362f74ea04d1c427eeabb416c4cd12588c7e6c97366f6"
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
