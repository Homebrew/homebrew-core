class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongodb-atlas-cli"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/mongocli/v1.28.1.tar.gz"
  sha256 "2345ab3029b6fdf293a23a389f86fc6f866da2bf0290247fbd769777b5ccc2ff"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^mongocli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42c97f4e8c4d9364b0767e1aea8c9f48548cdf7d247678a44af0cace9ad9aa4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "859f405dbaaea7832e8bf33d7f38afa9574096ab61a61b0d5f77f4956603eedb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df89b8195ba8d37f1a01842d828ba57a91f390c8f138c33af031318b8a6b1624"
    sha256 cellar: :any_skip_relocation, ventura:        "5cd4d35c3516e54ec9b32e27370d41564c948f92f1a836b6e2003ea1dcdc37fa"
    sha256 cellar: :any_skip_relocation, monterey:       "39346edb2c127b7034c06f0ef96c1e70799b32dd9451ef5ff9ed06deeded41e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "fba8d7d65abf083d4d2d09f2065bc3841e605a3d34069f2814a538d9dc90358c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a8f16691ba8469aa04303489b8a6f43fbf71cff5bc9477a4c9f7e4a3d77d804"
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
