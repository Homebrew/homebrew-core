class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.98.0.tar.gz"
  sha256 "2d55fbbfc42e7684e9af893205a2af309299d1d960c1a7ffdde5599df41746d5"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18407cd6b4fbd8f124a09d8fff8987b9482bd7fc4f23337dbe69917a522e6791"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d638074c9d8c6a232d3a0e3c8892d2ba6fe0e8e9f61ef6e093c3037156b2577"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7f0ad3b59f86016820c9ff2056c0cd7161e47c4b3a1d4e2ab967d79c353fb00"
    sha256 cellar: :any_skip_relocation, sonoma:        "6402891ee87487c276e82a1eba4a815b54359abec58a7a9362c76b825ee00251"
    sha256 cellar: :any_skip_relocation, ventura:       "7dc2af43ad7f0550c8cd7e5dadd3e037fd6576a35ab040f662bcdac9cafd7dd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07811c402fac007db59e9fa3fbc27670bcaf421360633198462d1777386ef28a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46a4f2f4802f1a94d14efad4777564a3a0ade43064548d262ab9a1fd72ee35fc"
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
