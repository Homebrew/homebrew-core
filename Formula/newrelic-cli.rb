class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.62.7.tar.gz"
  sha256 "e17ee74d0e635b87606e430a77b04353a2d7eb485b8cb994346dbb546d172949"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57d743f2645b00db25c0307485c121b1cb5de9b6d3a1ae97f28df42a2c4817c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb5ebded4b7c78a492d63c85225985e0f0a808863163d014a0f3cc8d69b9b29b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22146e3619a25bdb3ae58658529db5ef7654af3ac27f1b34e3f53814753863bd"
    sha256 cellar: :any_skip_relocation, ventura:        "fc0ead156dbc8c88d9ebbc929aef2927edda77967367433dc97b5ef3d910b368"
    sha256 cellar: :any_skip_relocation, monterey:       "51b20541145d22344eab951562fa8db3847ca339c3950b9121b3fd979da045d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "102febc59765a898ccb9a8cc56805a2cc0f50894bb375a4a0dd72b88287b2cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abeecfc2e237abfab547ff077b9b10698c6c7b520a9484631e6e7ce12de74cee"
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
