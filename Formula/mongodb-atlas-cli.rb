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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "459a6606b11de4755162a62624a392ae782326ecd19e5e5bd61bf718599515be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36f705b25b2c1d504fae796c73cd62f030f5871b0a309cb2c7c7a09a20532253"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36e2d981baf5d72b1a478a20bf179a27d63263dacee330aa0d7f95fc13a66d5a"
    sha256 cellar: :any_skip_relocation, ventura:        "f9f5dc522c10ad6988c7527904903fcd132e820cfa5532b2f28ca39f001c8c2e"
    sha256 cellar: :any_skip_relocation, monterey:       "775db6786927dea24651c67c6a875e1f93745d03351d7833ce9277e6be600e06"
    sha256 cellar: :any_skip_relocation, big_sur:        "6004467c7b5172fd401172a6bb5f82521c53efbdcf779eb751169ac36533723a"
    sha256 cellar: :any_skip_relocation, catalina:       "12d619d8b05bd59f2a894f621f315cdb72668fbac970723a8e3b75017dade8c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e68178bedcd3566973beed50b628f874d09788c1a473caadd564b5737cea6e1e"
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
