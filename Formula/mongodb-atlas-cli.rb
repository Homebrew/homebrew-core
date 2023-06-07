class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.7.2.tar.gz"
  sha256 "f64e9d58e19f6a327f123fe0a12d9292fd648dc093cf8fd6c11643d944af04cb"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b147abaf0345021ef4acd56795d0a69913f9b65b1b4a97b578e63667897a0dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80e83098e2ace99dcdb75b58c00dac041d747b6decc567bc400094088a737824"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54166fc705567df582a618f5615e95c8d70540b05813fb5f9a8856c244046b17"
    sha256 cellar: :any_skip_relocation, ventura:        "491d335cef84af00448a467f6375a90a96cf4eb658468d0358b9f58dd390876e"
    sha256 cellar: :any_skip_relocation, monterey:       "892719e2a6c49915a49564ab88ab0b58d01a82da1a98ebd5000781bf471ad209"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a51db2936413316066c60acfaf934baa6f2c06d405d4e5d5c133a3f626318ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "818f62b717a3bb1c5366b9cfd516aa481eedf5928f3e31ba1f54b5c8187b28f5"
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
