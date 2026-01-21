class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.71.4",
      revision: "8a679b03a6d78c29a229bd792715b8b0fdaac6d5"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed566f7bb18b82c865025764d0f418a8b3bb026c46a2bf7917a0e14200eb317e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc8509fc02238127a139a88dbb89d90df0b60c10bb0221d86e1ef99c4afdbdd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef4fb0614e7d662fd0b2925b37969b18a9c81f8f0b2c55720f348eca35915a03"
    sha256 cellar: :any_skip_relocation, sonoma:        "03cdaaa101ec63b64f8f546fab1970b66dca85df0e4c358c58c50e31ec482354"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82772e07fc38afbb7f72d814922170e8b1f8b25667be32aa47bc67e294e263ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e143e8ef164347dc85a105beb6fdb30bf782e6a7ce3c046f97b195dd64aaf97"
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
