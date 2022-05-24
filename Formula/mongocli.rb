class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongodb-atlas-cli"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/mongocli/v1.25.0.tar.gz"
  sha256 "aab93f9702df598461f0de5a7d8949e4c1d45c73c1f01198cff0d60b12ac9fd9"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^mongocli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2c4bcd9669f917539527d17707777d70f543149cef622892cc535973cbab543"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e4eb9294305b73ecff4271244b878328d1274dfcbe336699efd64e93454f230"
    sha256 cellar: :any_skip_relocation, monterey:       "7412bec19faa0f24a1fc92f11814568202ceef74630fd41fc5075ccf7624ab13"
    sha256 cellar: :any_skip_relocation, big_sur:        "9dda5f2444ca565dd74fbd11addbfb4432411b2848b487dee9dbbb5580b843b7"
    sha256 cellar: :any_skip_relocation, catalina:       "031865b3753eb37d2a98efbc20c88ae761d1240fd94ef0bd9d1da0c358857629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c858bf5941d4542813b9cbbcb4097a2220955fc2e03fe19489055d4fded14442"
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

    (bash_completion/"mongocli").write Utils.safe_popen_read(bin/"mongocli", "completion", "bash")
    (fish_completion/"mongocli.fish").write Utils.safe_popen_read(bin/"mongocli", "completion", "fish")
    (zsh_completion/"_mongocli").write Utils.safe_popen_read(bin/"mongocli", "completion", "zsh")
  end

  test do
    assert_match "mongocli version: #{version}", shell_output("#{bin}/mongocli --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/mongocli iam projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/mongocli config ls")
  end
end
