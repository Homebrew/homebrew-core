class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongocli"
  url "https://github.com/mongodb/mongocli/archive/refs/tags/v1.20.3.tar.gz"
  sha256 "4593179dea159a528b0afbe411a027aa00847fe75263388e52d55a96578c3176"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3d278ad35465e12300daad0e9f70162cbfbf36ecea95085bd62720250e8f9623"
    sha256 cellar: :any_skip_relocation, big_sur:       "7671eefec6ba2a72d9157d4fbeef109816ec10453edec02b77bf1dd74189b156"
    sha256 cellar: :any_skip_relocation, catalina:      "d4a207e590dab7f5a79ede0a8390d86dccdc75faa40fe4a6ba04d2128e7295e9"
    sha256 cellar: :any_skip_relocation, mojave:        "63080bb88ee9c1b8caa310f146ef398ecf4d7ee8479e20866db849c7f4b78f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc9f880ddec22a34522ebcbc4abede3376240ea55c89bbdf4e7fc3ece654e190"
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
    assert_match "Error: missing credentials", shell_output("#{bin}/mongocli iam projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/mongocli config ls")
  end
end
