class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.97.9.tar.gz"
  sha256 "2d979bda7adfba98506c16d21855e5bbac09dcc36dc84ee0a061080e271b26c7"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2550b7606c3e8eebd40bbd6bf8414e058664a43a36cb2fc3e4202c53e995a2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20a2888b9e8773ae6fbc0a9d19be2be2ff16b7a07103d7e99e1408469879b34f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "69b0af5592186ac90ab1ee604f5f0ace3d9d303ad28c1d961d1433a42e72f474"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a407f595aa9688456f9d87aca7964692408f92084a910d876f6199f8a74fd89"
    sha256 cellar: :any_skip_relocation, ventura:       "47ce0e5d1a1460baa534faaae29d9ec2f2d889974b46a2555eba5ce3a548ffd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28fd373222d1bb8e106aa92c9147df5483e87d38bca6097396219406180d3f67"
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
