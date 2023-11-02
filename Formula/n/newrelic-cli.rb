class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.75.1.tar.gz"
  sha256 "daa235dbf7c3602ada7f1de62ad52b6d46c65a3121282170a8969b6fe162df9f"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecfcd2d5b2685e70c95763c1bb09115f7655e2e1e5b36a1063fa624d2dc63dcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0e6e93330bf6d464d02fa430c08729cd2b21cb83ba51f962bb047cc0b6f019b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5f7979e9f54dc3ec7a5131758e3e9b3b051ef54f45f58a1afc7a8d8b11090dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1376ad956ce773b880b795dd0c93d9ae75faba18ff77e5691ee71b52b0d8570"
    sha256 cellar: :any_skip_relocation, ventura:        "35037cdcbf55b9cd1cd2db7d611b4e714545156e90a763ea2340f63cff8514ed"
    sha256 cellar: :any_skip_relocation, monterey:       "f0beeabac821a6a899a35b7e86c20f375b98ca1a7b6065f65ab646484b5cc709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17b723f081ebd8cbab95a8e92b81d809fe39c89c17032ce85809504229fb282a"
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
