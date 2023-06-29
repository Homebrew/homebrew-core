class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.68.18.tar.gz"
  sha256 "6bcf0058e773d8c6adab729fc7aa8472d07fc93e38853460e2c7e12d1c32e644"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "228b0a109bf50022d0a9e00e3b3945083feeba2b8f373c8ce704a8080d4062be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5694642468e46ece507c4f217b15ee0487f4b7b4589373553c0952e2b109e15c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61e54afdc3a6970ad82442b3b7f33f66b73d17d3def55be6e6517bde6d256381"
    sha256 cellar: :any_skip_relocation, ventura:        "c1a910a480d0a335891d74336f3238cf8c8f04a4f8ef0276361720ee49229a16"
    sha256 cellar: :any_skip_relocation, monterey:       "b2c5016f824f034597a8836ce19e489697fed0601068e2af6190dd159d274e2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bf67618f0c96c1cde3c23d931659e5460dd4dc4cad1ab6a513819b2e8f2eafa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "170c980b8ee6227371a307c95f4e1d47115c653181b80cb2397c571ecc802e4b"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
