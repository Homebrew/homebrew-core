class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.62.0.tar.gz"
  sha256 "266789eaa7f753d8fb65b924127f8c77aba007d0cabe7f85c6e18ac97f3c99c9"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bf2bc97891df714e70c224e36936a2ed9914811b35741bd12429859e109c8af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78c7fe329a5427f9e9129d1214029fbb6d6cb7acd5f886f20189008ab6f97095"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f19b0a0aefcbd3630a0ad5434c0193bb0b16e5cd644afb4f6f604e477663642"
    sha256 cellar: :any_skip_relocation, ventura:        "050fa5b0a0572573807818d0dc42671e9f049fa3470d5eb735c26de600a15545"
    sha256 cellar: :any_skip_relocation, monterey:       "37073e5534c1540c68df81dc5e1847000d136df341c659d25d365daee7f055c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c06d919e7d6472b1ebbcbd4a6e948c53a1ec7b8a9bc634b9ffd195b147bdae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1dd0165a1fbd96b40b907d77419ec41bb0b5d526559cae2623954f981b120f5"
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
