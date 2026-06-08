class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.112.10.tar.gz"
  sha256 "c2d0bd5ad46101857ee3d65224b51154a6a4d2495ee06b0ab281c80b752d2453"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "480e88a3e114c24ef917532984d1d9bdb46758f11fa600e77dc9b31c9cd43a88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9de474913f8950f6ee846c033de5640b98fefc5563d281b1bcbe843d0ed4c49f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9c5161c77cccfae447c87bf8544d6d0a18d30270dfa7c5a7e367a49c92816fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "10b7c44126c6a4c1b8caa719098badd629e437b9c2a35fbcff7cf262cb3858c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b0918c6cf23bcca041800698b1ab9e1500bc7bef7ade0b593fe8d54fcd60e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "016043f6ce0de0eeea4c983f1da982d59c2b5cf359953315b0c29f086d687756"
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
