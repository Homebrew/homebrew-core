class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://www.mongodb.com/docs/mongocli/current/"
  url "https://github.com/mongodb/mongodb-cli/archive/refs/tags/v2.0.11.tar.gz"
  sha256 "1c17355ca867107e036b09c77e8ee498833337e276cedd304b6cd49390e7563b"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8f76297d43b338a2d0b0c9059bc8a53fd288ca0eeb774b773ccdc986ad079e47"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c47ae288da55c74d4a312a98641748265c8fb41e40492195df82e8bf8063d21b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "70647bc0d560d4eebb02b354e91041e9c4042188cc43d587a2f447934fed31ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "570fb0e5e720d9df95a4c71b9bbf95443514b3162c08ea3e02149493c10cf731"
    sha256 cellar: :any,                 x86_64_linux:      "973f27779a54c33dd8e967414170c8bd8aa5d417aef643796319c3f01df4340f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    with_env(
      MCLI_VERSION: version.to_s,
      MCLI_GIT_SHA: "homebrew-release",
    ) do
      system "make", "build"
    end
    bin.install "bin/mongocli"

    generate_completions_from_executable(bin/"mongocli", shell_parameter_format: :cobra)
  end

  test do
    assert_match "mongocli version: #{version}", shell_output("#{bin}/mongocli --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/mongocli iam projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/mongocli config ls")
  end
end
