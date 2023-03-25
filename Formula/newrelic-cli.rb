class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.65.3.tar.gz"
  sha256 "8db6ae9cfedc8fd7386833575679a4493f052038f90972d332a376fa66141835"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8bb5076b9e12b2f79c504892a4bd06e208c937e6010983334623dbf982d34f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37a1b5afe58729155c66331cd0973c028863d7166b13385a734b4629e6bbbe49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c5f536017ddf3be885b0bce0b355ae7a7cae2766752ae06585ea4c6f43a268c"
    sha256 cellar: :any_skip_relocation, ventura:        "8432bf40d7f83f0c18f3a68b6718619df1ebe7ec7873ba2a02d0d4a1726a573d"
    sha256 cellar: :any_skip_relocation, monterey:       "9d361cc788486f83fbb21b67707bc0b5cad4adc7ab908d2b16d3eb8d77db7220"
    sha256 cellar: :any_skip_relocation, big_sur:        "b12cbd08aca6010aa3a02d5a157903779639a662b8e6d1220687a48a346e1250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8610c62f18f0d41c9b22faa1c6476a2f6b618293a4c1a702f730fee31373c375"
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
