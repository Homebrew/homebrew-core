class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.12.1.tar.gz"
  sha256 "98b1f25f918dbbb3cd99d76a842b2c5ba2f16cac4c3fcdaac1cc655aa207e119"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40d3fbc05fe974f27083007e1727c274b93cbbbe65f24088c1b522e634b9f860"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96e26d041ae14a85399f2606b1914211511502eec314bb2494fb7dd24f192bff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90a68c017acb0989290e1a3ca48d9465a7e78d7199a138edae59f8d63f67ddab"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5357359324f5e524151352a05e52565c46a138bdc3dfa587ab05f2a5d867f78"
    sha256 cellar: :any_skip_relocation, ventura:        "2d461c1713135482c97d79e16d4973c21af9e332669387e71cb154015e5ba739"
    sha256 cellar: :any_skip_relocation, monterey:       "5a0c8bd9763983422304e6c1ab2b3f37f416231655f3249f08bd99f216c06c6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1438527a7866202b7d5b44505792fc19371297c5f99947023a2edada8cd962a2"
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
