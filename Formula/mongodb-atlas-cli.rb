class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.1.5.tar.gz"
  sha256 "54cc6fe29ce95bbeb5d9a41c6b9475523b9127e7ae71ae04c5e7a7a6d505b4e0"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5d986502f9a14290f9f4343a0b22fb677909aac93b958abe24cd79c01581359"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f12981617721c367e8c8af64a2abe623cc92d50385b7a482531ef5ede5267a4a"
    sha256 cellar: :any_skip_relocation, monterey:       "94ab895367a0f5485b82b90a5842d73591dccf1975c4cbf1ad6726d3b499c506"
    sha256 cellar: :any_skip_relocation, big_sur:        "155f81e055c25f8cadedbdacfcdda5bbf9b86b970fd5edb0bb10a0c4bd5dceb4"
    sha256 cellar: :any_skip_relocation, catalina:       "358cd646ab147da59fad50a3a907c0fb1a9c7cd66170773408d9453cb6adf1d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdff10b04e11e08d38a13cc77e54311db78de50746c6c392e65b50fe0ddafe60"
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
