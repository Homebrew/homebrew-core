class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.78.17.tar.gz"
  sha256 "5b75417ec8052b96854110df82fda264da354a1b10dd7c78350b7da569afb2d5"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dafb9f233e6d8202f39336e2b0f5cc5434a9850f30e50ea96547a53e5f993724"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da1f90295f9d166094edfd80bc7a23e26a196753a9535aa45b3cf9464a0ee539"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a1c2796b8eb0909826e365d8514410ccc03edfa7294b45c6fe269142f58d0b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "057bc4355849f00717586ed8d224f04edace64d9c90435779f2099d1f709ae01"
    sha256 cellar: :any_skip_relocation, ventura:        "13f3ad4869608d94e78b3822d78b90dd5937ab7abaaade92a6833a01b050d7fb"
    sha256 cellar: :any_skip_relocation, monterey:       "5e9d488a2d79fdc3d0ca349a9773fbf6090f6f5aac621295d35a7144d2396cd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3daf3c5970ed1f318d3597a9fb8467f21c570e113581ae8b5c35bbaee82360f"
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
