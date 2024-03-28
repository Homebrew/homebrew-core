class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.80.1.tar.gz"
  sha256 "da81349c0c4b00ed0fa473bcd588f6d3d5e3d8dac1c6d0c75d65c55d448e8f90"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81cef14e158f432c09b8e446cc421e1b211efb16b16e77901c7e0c24ce2c611e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c36e1353afd8ba4d9b3833065f929c4e118392eade7e888b2ac69194458627c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dd69990a3b0505e51377c86ea1a5b1ba2a551017d4c37f5b4782c02adc33be8"
    sha256 cellar: :any_skip_relocation, sonoma:         "d18ed0ff9673e9934f864e930fe7943b4bf8d5a9c3919942fc7f1819794c6a10"
    sha256 cellar: :any_skip_relocation, ventura:        "bddc1a112767c2ce5b9d6f0838f135839d98225daa313b30192777b1f47f66ae"
    sha256 cellar: :any_skip_relocation, monterey:       "d39f528377b5ba548fb1621947e85bdc240e91418f7bdcd4683765276b76ed13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c278903ff87826fd43144d503816bccc7b040390bde9779f1c81c1c14f9154d9"
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
