class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongocli"
  url "https://github.com/mongodb/mongocli/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "e6ebc8855c897980f7d4f962c106e5b0eb2d3e390f90492397e0774253e7af0d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7b02c8154f2c3778c37c9b7a7a790be25da0428be9ee6981a7b1f9afe86c51b8"
    sha256 cellar: :any_skip_relocation, big_sur:       "9cb752f9780c21f30536cc69d901cd2b3f397d496d809e9aa713e2e304a06294"
    sha256 cellar: :any_skip_relocation, catalina:      "9da872e3a23c7ac7ded9f25b5db12bd636de5f992e1ba19e3cebe9bf7816d70b"
    sha256 cellar: :any_skip_relocation, mojave:        "ca7319197c31a5c30fe49fd606c228e38d6ec33d0f5e1c98127e8f629454b60c"
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
