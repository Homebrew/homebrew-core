class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://www.mongodb.com/docs/mongocli/current/"
  url "https://github.com/mongodb/mongodb-cli/archive/refs/tags/mongocli/v2.0.4.tar.gz"
  sha256 "30ffcc61931147c6ace31e87ac487cc2b125a6cb65178e63e8c0f73e6b454cbe"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^mongocli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d0c52b4c6e706d1389f19727c753ca29ef1a0940b4213dca72482bd231bb5db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "440b512b69c89ab20fbe28fcfcb998eec7a1aae02f247fd5a0371126ff189ea0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1b3f86cab303584d947c08fd06bde708c713a3e5274cb4e9f228b9e4902d58d"
    sha256 cellar: :any_skip_relocation, sonoma:        "047ab97e0d080a6ab9485d44637cdfc5c519e7f1004263c34149ff09b176d24b"
    sha256 cellar: :any_skip_relocation, ventura:       "32b03be3eab6e447440e4de98a8c80f72cb98823266d8c7d9c9e357879d83529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5be0afe265ea707d682d30cfce89888c5a20e51068aa0ce44ea0a6b757223f1"
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
