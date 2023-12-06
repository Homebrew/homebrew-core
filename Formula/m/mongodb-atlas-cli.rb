class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.14.0.tar.gz"
  sha256 "385c9a4a86527643ff5fd73b9b59ea4d8c95dedcd00f7726e82454f4a90253ba"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a193765773b747fde1481640cdaaf8547c4dec3e44c4f65a9c90ca92fcb53a8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ae1598815161c59ac2c0a35e17eee41945ca320e2b3aadb7d06fbdc71780aa1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a6e8b57795256d3d32ae1a05fc0e98f6d6d9ce1abaa2b828e2cbee20410636f"
    sha256 cellar: :any_skip_relocation, sonoma:         "671a956860b9d9ff6575b628f36c2e5068308af897c573584147cb9dfd0c3ba0"
    sha256 cellar: :any_skip_relocation, ventura:        "2bf614e334149a3c9ab4e6272977df9c90cacd652dcf557398bcfdad27cf4a87"
    sha256 cellar: :any_skip_relocation, monterey:       "829a6329a397ad64c242f0ec31bcee28e86f1a74e0073e8e081961a46a5e67ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9e9beff2e9938c394c898bdc96ce72fe701db29511848bde7456395aea9f620"
  end

  depends_on "go" => :build
  depends_on "mongosh"
  depends_on "podman"

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
