class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://www.mongodb.com/docs/mongocli/current/"
  url "https://github.com/mongodb/mongodb-cli/archive/refs/tags/mongocli/v2.0.7.tar.gz"
  sha256 "39060cf7b67650963b45e7e8f5bb3ba1b91187adf4bf779bb88fd4d43782f71e"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1f35ee0b5565c50098d5153c9ab3fdaeae8e5980b9c3c247218c232e130e507"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c69443a3dee4214f6c7f4df6389658dc3559454f692ad9816e59309fd9bc50bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "772f76e5ff26d57ae8560413ce8164339f0189f91b22685bf9b6498590932af4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ec225fe62b327fc3ba91969ebbf1b5a84b568070e5152b2f657b5cc2f39c192"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c34d8f7f035603070b116f1bbc8067ea3a389a0ef8a57662774dd1c0cb98780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dea1584b44fa20fd97342d27690b9e0361fb0b05d9be4f85f864b9502465b592"
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

    generate_completions_from_executable(bin/"mongocli", shell_parameter_format: :cobra)
  end

  test do
    assert_match "mongocli version: #{version}", shell_output("#{bin}/mongocli --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/mongocli iam projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/mongocli config ls")
  end
end
