class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.50.1.tar.gz"
  sha256 "c86d321d46711cafe8e9d74f1443853469f74f7a0ff5f852d6c20bb95cf1fc56"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c63cabb5282a8dcec2f0fc5ca48cf9d98a4a054361139413d8cb5cecc178ad8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e125ddbbcd94c88d50cf30a3a7f7ec897e48a0dede6e3ae560e8bc3d57e4d757"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c63c6c754eba84baa7c44ed13ea3e91576d89a14466faaadab6839f86a320029"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8ec4777156d09b55447fccbc5cbc7892e7813b2e737eda187da67f4c90de054"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be6c4afb2376baa74202f3d1f178b1f6aaf39343118ad86b89572909c6383e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75be0e5b8764951d8a32d746f22fd6649ddc16343fa21468786910ea28238884"
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
    assert_match "Error: unauthorized", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end
