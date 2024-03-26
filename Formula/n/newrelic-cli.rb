class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.79.0.tar.gz"
  sha256 "75f2d5e51ac0fc1bb4583a4060f1d8f2a40d0167dffa320322ab4cd098adc963"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea3b288536089b4f29e1a45dddac25ebf70046a341d7c59fc9f1461924582f97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d91911b7e4b84b5a245e081cbe7bd5a7e97be9cd87a21aaef5d4b64b992b95f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60ab69b37700c98255e343d2c9c0db38b7d6d7d81cf2be114335e1260e8c7be2"
    sha256 cellar: :any_skip_relocation, sonoma:         "14b3e120b1df65d99ec5fd43e934e07e7cf8c447fe7c17ed5850d94319c2207a"
    sha256 cellar: :any_skip_relocation, ventura:        "83f9f228f0c322e184fd29b00bc973c479ed087dfac575014191ee8f6c3f301d"
    sha256 cellar: :any_skip_relocation, monterey:       "0b9c0c8c8e42874e8980a2805b0cfb942187aed85ce0efdb95aa41fb2d117a26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a5e6e107730d29ace636903439bb1899f7ce8c2cc628e4e2ca288a372acfc6e"
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
