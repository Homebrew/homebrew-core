class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.58.0.tar.gz"
  sha256 "26a5f09f8beabe474b064a89956e37714c94ad5934b2099eb9bf9a92d937bf83"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e069a9a43bdb1a407968e92b542ffef75cb633f1996011928e7f9fe851e50f98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ccc5daad5b88016869e9099e5cf1b138672f1f485601dbda425b933e1abef5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d105064b2e114b8c61bfd100a17a598a7f7c8cb0d9a5b0704f3d6c325d54a97"
    sha256 cellar: :any_skip_relocation, monterey:       "173d701b149bbe34a24a32a384c95027ef9e7ee1a7a8423f7cc587a5be76a14a"
    sha256 cellar: :any_skip_relocation, big_sur:        "26bdd24401b30977e1011e2822c652d1274d7a9bf2e01417f284c2798477b4da"
    sha256 cellar: :any_skip_relocation, catalina:       "97f0c0dad608549df9915abf6ee0b78a9d6284f83881cc44dfd5ddd2798e6751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b57a0fc937ccf9bc94b0b8e4034c4e0be93d0381f8750a3f8c3593637d9bceb5"
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
