class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://www.mongodb.com/docs/mongocli/current/"
  url "https://github.com/mongodb/mongodb-cli/archive/refs/tags/mongocli/v2.0.3.tar.gz"
  sha256 "c2690d45ed14e3911d5d71ca4242452391c3096b03a42c1e8565f93f185354a0"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^mongocli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d459bf3e5004a63af1963ab9c42cae7afe021d11a1cffc90ce05ef3bf6280089"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c7eb997272bb45097f9b182ec5b913ae804599585836a53a858c9b3e152aac7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c5abb0cc49a70dfa9b731e999abd8bdea74cd2f56d943779b013cf555bdb44d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb6cd83b961c50c9df50dea9bfdbc9b4d21a8802c30ae9953d7526a839614a3a"
    sha256 cellar: :any_skip_relocation, ventura:       "44cf7ab5b5ed2d99a01b8b89ae98503661606b37bedb549302c54dbe5935813c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffc9463232d4aedd74dcc6e0fb32dd4b5818615c36cea1c6bd38955a4b438a53"
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
