class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.26.0.tar.gz"
  sha256 "33232dcddd525c3faef638a25c1c9df81fdaf809be96f43c803a19d233022008"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "502eed65847c589b72f3aa69ec7ec1d4f61e090e8cb5eab472f014db0ae13778"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c61fc64323eb866d46fffc992bf9018ff4bd7fbee18fd5ef92d7e3c47050cf1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78a6b5581097e107ac9af51d61feb32ff57759b61ef0ec941b39cb1db31aba36"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0b9b3ee56a98658dc08225aa7c7897e35038da94130d2fdd758722be0609ece"
    sha256 cellar: :any_skip_relocation, ventura:        "34d467c636b25f157c2bc39bbfb5bbe4e6695a71883c98a29ba2acb117fe7e47"
    sha256 cellar: :any_skip_relocation, monterey:       "735acecc7695de154def5e6ff8767c5a785674c69b2f42023c8c44fa83aaa3be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f648ae3918a4a7b6b8a9d0b87d701bcc476dff92f5efd9fcb3c079bda897206"
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
