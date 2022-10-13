class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.2.1.tar.gz"
  sha256 "c7e9a203a3ad1fef7cf16910530c337b92049b3487f10706067f7d61989f9d82"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc2d83b9caa75ce9cf1e6d9fe706fe84eb16ff2dc085d7be471ad25ae76ab517"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "640307bc674f6c92207e395d6b29b9af9f3d1ef891491e059ea47c0b4d253cd9"
    sha256 cellar: :any_skip_relocation, monterey:       "41bcf8227ddecf7179dcf102303b3cb1a8bf45f4762384764d6fe183a11c2353"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffc412eaaa24a9294339bcc012542025ae6eb74c3b8b075c591d6910859caab8"
    sha256 cellar: :any_skip_relocation, catalina:       "f4940a8f0b4674f75c889cc1342e73b0ffd6525b32e9239dd6a27fa69853c547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec5fa421cd84d7311b47bae60117e7fc509f179c740696bffb089523f4da2808"
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
