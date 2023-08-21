class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongodb-atlas-cli"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/mongocli/v1.31.0.tar.gz"
  sha256 "2967a73d489b015172df44873ac327f844a63eb7db87ac1d7e82c78a181957c1"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^mongocli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ced0a347c86d1d591eb111adaa5da5f0e26010808fed8bd475c7172db0a4a473"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edd7c3e60f52a2b9589a7f7fabdcb4fa62509e60b4ebf064c9584ccdbf4cd903"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b01bde58a3c4781c8197b04f401b5acd39fbb27b4a2b849bbfc24691f9f7fc74"
    sha256 cellar: :any_skip_relocation, ventura:        "3cadf320ace428df292dc1693866f52510c311663f914a406b39b53ec0c169ad"
    sha256 cellar: :any_skip_relocation, monterey:       "eedadd4915120c905220340f45829c7a9d258db6780af6e015ec08152b64f0cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e79547b6542ea438a35759c42ed27e98cf4e45a7bf2ad6e97b65f19d121ff75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5c26a12a1a52f6caf061b5a9e48ea52412ae73a7eb7197addac32fc55857821"
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
