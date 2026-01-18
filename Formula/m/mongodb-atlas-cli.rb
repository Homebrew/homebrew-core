class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.51.1.tar.gz"
  sha256 "97d90797fd25b5b438ad63400079ca03fbae8d5659b2442f1e1cf2753544f7ca"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2d88ef2d7dbe88db11695adfee5d6d0c6c77a1db53f9569e0f7c11a746aa826"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4a0551c9c6510f21bdf307eeee13d6966f0064d30e3a63d27e579c32127ab2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6538c161afa32a1ac176beb76a1deeb7561697a94354531d7575dac3676cd817"
    sha256 cellar: :any_skip_relocation, sonoma:        "047aba70616f0f48b8af7cd8534402d7ca98b8221b84afece80d5e66d27f7b47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83526667f51a3be649769b846148bc57f77d6b5be551a43952fd3096c7c2a7db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d53e70c8db344a05286c8a0b65d5c58c8acb448f8c07e7a4e9f257c792a251f3"
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
