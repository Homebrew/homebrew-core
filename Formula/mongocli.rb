class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongodb-atlas-cli"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/mongocli/v1.24.1.tar.gz"
  sha256 "b63aaa77c397f6a6438142559551527d12fc3abf58dee3a903d3eaf4ef928868"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16912240d60ab1bd7b2fb20d7db73a438cb2ef1dc53784487a9b00f17fcab531"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c99cf5343c43a10e8686dac00dccac788f9bed3d57c85ab688cfd2d6173af2ec"
    sha256 cellar: :any_skip_relocation, monterey:       "125ecbb70ed3a03c19e909a27375d76aa2d35cbfc793af18dc4b4180452bffba"
    sha256 cellar: :any_skip_relocation, big_sur:        "1117de116deb51f38d13c5d5bf6ee84bac35be5bfedce02e277c764a190dae64"
    sha256 cellar: :any_skip_relocation, catalina:       "00bf954883b4aa5d8ed19da373a12f9203fd056457ce0f22864e8c8ed40fbd46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df845bd3d67672cb468b00614abaa89d7a7eff35bb30a6cde67cd0236fcdaa7b"
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
