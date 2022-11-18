class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.3.0.tar.gz"
  sha256 "619036388eebccc1e83dff525fe67992133788f26d4a64945811fb776b87fc45"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c7282e5fb05f6c1821ea6fb874c3bc2c762b3d3bf876edd8d1acf4664f6a9f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7e581be75db1b086a033877196b898dee14774e85ae2e48718845cbca73070a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "472d2af957cb79d701494c5633a8ce710e6d21894de96791127747918d4bb285"
    sha256 cellar: :any_skip_relocation, ventura:        "e6f78be4672c7498d6a8cda621ecfdd119b409ca0fb5f4cc65ac27f7b177f95b"
    sha256 cellar: :any_skip_relocation, monterey:       "5dcb37456dc90a650db229203b3ed9c442fdaa95fba9e0cd38b4df572b092936"
    sha256 cellar: :any_skip_relocation, big_sur:        "91f9ff8c043776788b77116c31f1b69a54fd085a1679b0af39eee0926db92dac"
    sha256 cellar: :any_skip_relocation, catalina:       "01cb5857f51bc43673c0ffb248e60b296ae3df23a13fa499ea97de2fe191ea71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1dbb330c8821c28817d561d78d9347fbdaa25ace541b0e668d6eff26f050cf5"
  end

  depends_on "go" => :build
  depends_on "mongosh"

  def install
    with_env(
      ATLAS_VERSION: version.to_s,
      MCLI_GIT_SHA:  "homebrew-release",
    ) do
      system "make", "build-atlascli"
    end
    bin.install "bin/atlas"

    generate_completions_from_executable(bin/"atlas", "completion", base_name: "atlas")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end
