class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.96.0.tar.gz"
  sha256 "bf62e8cff16232fdd5d1851223e2e866e71145268774942268f9c6a2e7884082"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "987f7d0c09d3ef9f0b3ab9bb9b281ae8ccc60496122498f9669291c9ff9bf383"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c805d584da9e1ce3d007447dee9596ac75728bd167d6e1bf3530090f404eff94"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65e9f9b048cc184678b0f6e8a0df972dde5ab7b87804b9d4e4a92521b57ffd45"
    sha256 cellar: :any_skip_relocation, sonoma:        "e560d0216da8636b7750620b38f6e7f6db73a719373c2bcb200838c9fd182a52"
    sha256 cellar: :any_skip_relocation, ventura:       "ead04a7b4ba0b37a48a6df37eaac58e1ea95e1e4f7402c0ae19627815976f686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9d7de5f03fc8423e49dcb0f6d8863699b53cfdb3ed6b087998285fbbd2d74de"
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
