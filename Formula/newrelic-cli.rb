class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.57.0.tar.gz"
  sha256 "9af5c2d1fa38db75381ccf38d5a175313c6650b2542c93c9a301a63cabf53e48"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a842777e4f1c0ac7b84f4e51038c4024c74b460411dbcc01cee2da71353338cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b26e841ebf96d82f3c9a8dc17da7b37b111609975d305216ef488a205e85fec2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "415cd5af066c7560c9d436ae247258151f76bca412ef5d9d3beaae90a552e762"
    sha256 cellar: :any_skip_relocation, monterey:       "7fc94b2b8870b508ed083c655be3620f557774adef73b0a81e96279ae776eba3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef69c14acec00edee14fce15cacb6f027230fa8bdbe94ea091ddfa61d83321c6"
    sha256 cellar: :any_skip_relocation, catalina:       "59ee94f290dd74c33b17977b9e70d9a62ae7566162325ede9cde74933a0ebe09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3bf2c90cb6c47eb704f344ea0f2659fff624bdf09bc7bd2dfb90a63dc4c3148"
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
