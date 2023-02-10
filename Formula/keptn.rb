class Keptn < Formula
  desc "CLI for keptn.sh, a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/1.2.0.tar.gz"
  sha256 "a9c53aaf753d91a3776abb3f0a80822ccef27c14fc620b56f9906509ba392d48"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14e9e368f2989b160e11e3977f5e3eb1f553c132301b51a7d8d6fab27ec3945d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b613dda46b52ac4d2bd64b021a6c69e563f5d3ae830430ba3d3367cc8143467f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82769ac5e43cf547acefc157229df60a970f6a755658ce1c7c8f55d10161814c"
    sha256 cellar: :any_skip_relocation, ventura:        "64b67db9d184dd9f254440491db60303c3be14eae4bd24cb7373163299a338e1"
    sha256 cellar: :any_skip_relocation, monterey:       "094adf8ce83af2caa2973354179fb194e2371b3b354fdeedea2803ef8331b384"
    sha256 cellar: :any_skip_relocation, big_sur:        "e160f18853eaf2adcfc3310ed25de4f88e4ca0978b656b97509c9ba40af02711"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "277d4f4357c7ad1a8f83594f2674760ff085cd25bafb8cda74b1329d08dda1cf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/keptn/keptn/cli/cmd.Version=#{version}
      -X main.KubeServerVersionConstraints=""
    ]

    cd buildpath/"cli" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  test do
    system bin/"keptn", "set", "config", "AutomaticVersionCheck", "false"
    system bin/"keptn", "set", "config", "kubeContextCheck", "false"

    assert_match "Keptn CLI version: #{version}", shell_output(bin/"keptn version 2>&1")

    output = shell_output(bin/"keptn status 2>&1", 1)
    if OS.mac?
      assert_match "Error: credentials not found in native keychain", output
    else
      assert_match ".keptn/.keptn____keptn: no such file or directory", output
    end
  end
end
