class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.30.0.tar.gz"
  sha256 "4fafbd50316b66922f794f5b2a0f2c490cd9613da2f35d27a002289bf6e78329"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2312f054234342400f2fd1993f45a04c7fda3d6f23ff3a02eb87a27aa194c141"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08146fb15df60ae47759921997183887be7d709f6e9ed54e090f50d8618a3164"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87e73d97eac51ed7468f66c1e01855054fe8226e06f35ef0c566e14a368e745d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d40abde556dd85ff9e654266ea227e7c5668ac72081200fe5a02bb7fa2a5266"
    sha256 cellar: :any_skip_relocation, ventura:       "a46e45855a3231fa73d948d206ac2a7e61f720fc041581e42d0466d2f8dd33a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52286cbf75e8d02c39be86cdd114b97802edb955595d8f6ea5d6e6ee549f6436"
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
