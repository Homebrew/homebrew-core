class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://www.mongodb.com/docs/mongocli/current/"
  url "https://github.com/mongodb/mongodb-cli/archive/refs/tags/mongocli/v2.0.6.tar.gz"
  sha256 "f345dfa561e71eea9759ddf29ad5961c57d63f4b43c7535ba8a99ee48b849338"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df2157f55b136a6c6f150329be822cd6d0f560ca5a2ee52caea1d64417459658"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e445bc0a3fd26236eabc4b87c2dfdd255ec980f764ae5e7c131be20f46cba721"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "213f5d5a81d213da3f42c1831fad858f96f627fc47324a1ca8842335ab46f7f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a92abee340abedfb2c1ccd602141fe26db2c9d34afbbbcbd3b8b4c39519ed73f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7f11b48587f16bf224539129ad8f4e403c577c23f3f0dff7f5a30d80b0e8348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1fa1629c5015df5038e68c3f0a61f04648f29f5bc48b9e5804f8d7997161dc6"
  end

  depends_on "go" => :build

  def install
    with_env(
      MCLI_VERSION: version.to_s,
      MCLI_GIT_SHA: "homebrew-release",
    ) do
      system "make", "build"
    end
    bin.install "bin/mongocli"

    generate_completions_from_executable(bin/"mongocli", "completion")
  end

  test do
    assert_match "mongocli version: #{version}", shell_output("#{bin}/mongocli --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/mongocli iam projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/mongocli config ls")
  end
end
