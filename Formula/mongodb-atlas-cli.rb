class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.5.1.tar.gz"
  sha256 "b5bc79df19169a9fe9136c78e3701a32e1f88ba5c370c3daa763dad7f667c42a"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebdb3031d6d738a54be0245c2d55b96cbe7c5fbe94876c801bbf26bb35b0321e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f370fccf455830ff4500ed2ca5523649a0519f22a1e07d6919809ca411d403a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04d8a5fd9dabd3fd49be4da26a2278ea1c7343df9b518c1dff0d32141f09c3c9"
    sha256 cellar: :any_skip_relocation, ventura:        "1e813ead924272f233975943cf45be22fa25ca871c428a9bb4244936fac166a5"
    sha256 cellar: :any_skip_relocation, monterey:       "a852bd1193451dc5d73f6a4805942ae31672fd8b2d19e7ca99e839cfcf53419b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fee3d159f1574b21ad921d3a7107a18367d1dc978b42240a0b71f6b99c94765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abcd706ef183decacd6908a3e5ce3372beb693eca23de37ffe11ca777c4fd6c8"
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
