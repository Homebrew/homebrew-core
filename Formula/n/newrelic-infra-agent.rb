class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.64.0",
      revision: "90fee1410132c4887dac5546699c6ebfb7f5aa19"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c3efb0b9d0b2c739c22b0c8f76d964b90777fb648b3d0850b14b3e421a6e80f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68f2a63711dc0abeda29a874bf89b6c1201e185a34d1fdd4184910bf1cb6672f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47f59f20f9f986f39065c96458702b94a79ea2de7b0b21c748954945e5b43861"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b27d059e818daec5fc1e156542816c91b637b43a3949702830ce96eeb7a7b14"
    sha256 cellar: :any_skip_relocation, ventura:       "6878c0d430393df62194cc24a75d9f05bbc7d15473acb244be1346a6b91aa6cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1baf072a25148616b816f2d5958ed87e9e5e876ebe093b3ccbfa6840ac6ccbb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10758d54f803aff3a2a69ea6448c60f228d2fabf85c160b0f94731415ebe14b9"
  end

  depends_on "go" => :build

  def install
    goarch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase
    ENV["VERSION"] = version.to_s
    ENV["GOOS"] = os
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ENV["GOARCH"] = goarch

    system "make", "dist-for-os"
    bin.install "dist/#{os}-newrelic-infra_#{os}_#{goarch}/newrelic-infra"
    bin.install "dist/#{os}-newrelic-infra-ctl_#{os}_#{goarch}/newrelic-infra-ctl"
    bin.install "dist/#{os}-newrelic-infra-service_#{os}_#{goarch}/newrelic-infra-service"
    (var/"db/newrelic-infra").install "assets/licence/LICENSE.macos.txt" if OS.mac?
  end

  def post_install
    (etc/"newrelic-infra").mkpath
    (var/"log/newrelic-infra").mkpath
  end

  service do
    run [opt_bin/"newrelic-infra-service", "-config", etc/"newrelic-infra/newrelic-infra.yml"]
    log_path var/"log/newrelic-infra/newrelic-infra.log"
    error_log_path var/"log/newrelic-infra/newrelic-infra.stderr.log"
  end

  test do
    output = shell_output("#{bin}/newrelic-infra -validate")
    assert_match "config validation", output
  end
end
