class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.77.0",
      revision: "d6f62484521ce820a0b14fc2d09097286184ff16"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e7cd427b996ab401d20f4d90d79dd404a3c100902fd4c8f8c958a678f587aff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4321b4d5603598d186776f8e54181131c7a90f77565aef0acdd0e4a5ef56bde7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9da254549c56e2fe9612bb1e357ca6d8e70d3368e44de7b31abdd773b17a26b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce0238dc737d8256435ffa53629ca877be53f20803e0b229545fd0c4bdb8ae83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ec0ee3184166d258ef6272304c94bec791f8befd13ebec2305ca0f039e4b890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6145ddc90415220258632319dd0b21f0c409171faddf5240037f4ea11b4c3f59"
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
    (etc/"newrelic-infra").mkpath
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
