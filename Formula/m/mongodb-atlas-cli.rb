class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.15.0.tar.gz"
  sha256 "e2fef86ca5c487ac19f1d926891071cfbdfd40266f4fad0ffe9c90dd458235b3"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e31897b9a01e8bbc2d49d6b048c4bb3086b77a3f5c32898d638d97b74589565"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66113d39fcb9c60606879492217c462ed176f30fa34dedaeea24864dbe7555d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ad3ee89e71818cf46a4dff94c6e4b46f1e0a9d9252951c17367f65093c8aafb"
    sha256 cellar: :any_skip_relocation, sonoma:         "6339e5b9248804347f2448c67218854be99e0ceacb78456cb34e4f9cb8870ac1"
    sha256 cellar: :any_skip_relocation, ventura:        "5d7c5c777727963b0b60731e2e8e1d600608b4d9e7bd1548cda125853b7e305a"
    sha256 cellar: :any_skip_relocation, monterey:       "b2d53515f5b7000e8526b52fcdafda25a5d51c6e0ae161f4b853f8d6ac891f32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbf54e3ac90600bea0f5affdd83f87f2f60697d11a660dd3c8104df03b36d319"
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
