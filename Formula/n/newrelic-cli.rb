class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.97.16.tar.gz"
  sha256 "88d642a8671201d7df2da60eb8211b1aa4e78dc2666311ff644b92116da2fbfd"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5589089319dfb3eaa87fa85ca777e9e94e9babd1e9b4383d4e75f0cac17b6d34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09d9c40393d6a3f269dc03035d4b58b86f92d24465fa921a74f28b758f33d54a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb578980077b64883ac7dd797b0ea8580112558855d5c4d14f8c2f2b8cf1d92a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9abc80914e2a5082966cefe284b07d259f7b9b34db4c95dc027f13c8054711fd"
    sha256 cellar: :any_skip_relocation, ventura:       "3ad3dbbcc049ee6c4df3d77bdcfb880d101b2ab4c61dcb24552cea4ae85c463c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e26514f13904bf7615e66c2e9dc544b282b8dae4f042bfca969575045609ebc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "454c31dce6d43f734622bc23c380c017e22f8ae8f222be9712f0d780fef4e308"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
