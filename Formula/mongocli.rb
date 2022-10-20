class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongodb-atlas-cli"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/mongocli/v1.27.0.tar.gz"
  sha256 "cad2d02a8699d3cd621deb80439684db0c9b0697d1dcbfcc33a70c5772e49a9d"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^mongocli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "076ff8fc409d0fcc0bb9987560eef94ea5a6385a053818076953d556736e5832"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b42e5e1ee998d36aa436fc94a2b36aeb21a1673da3c0986e118a168f982b0c1c"
    sha256 cellar: :any_skip_relocation, monterey:       "ee6d4555d56bbad77386af9a340cf170b285ef19f75d0c48db83fafdea9e648b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5700d538527e9192171311a465debde181a666c47e910d066bbc692fff046b8b"
    sha256 cellar: :any_skip_relocation, catalina:       "9bc50c4ec87e03dd14a59dbfa6201d8a86ca6da3d88a9c43ef6012769773e7fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22ba57e3962435f4720bcc1f3068ea3fa66596f8b32888e47af1ac0d274f3c24"
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
