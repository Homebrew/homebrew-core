class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongocli"
  url "https://github.com/mongodb/mongocli/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "e6ebc8855c897980f7d4f962c106e5b0eb2d3e390f90492397e0774253e7af0d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "63d5b5d85491c312f4a5281949f4a0a222913a30f7510074114dceb931889b9f"
    sha256 cellar: :any_skip_relocation, big_sur:       "0d4898f1a7d22be2af306012ed4a8493ca99d480fb817541c3527a092b6d5964"
    sha256 cellar: :any_skip_relocation, catalina:      "6ae56c92041de89d54d7f5bd461091d68211ab86134c9042dbfad273979885a5"
    sha256 cellar: :any_skip_relocation, mojave:        "754c5f2e43d520522af351171376473f46707322e00f6d2776ee7c22957446b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56fa68e47f3116aa9390995e7c4190799dacb56f8d539bab39d734f2db087859"
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
