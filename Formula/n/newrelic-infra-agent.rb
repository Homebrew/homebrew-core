class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.49.0",
      revision: "863f924029eba595096f4a01ada0584ca045da48"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a93d519825cc10c3d133b90915327c045ec7804e08bb08dca5b6da1382b2b5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc7330b1000b5c27593217418661a50ed781772ab867625dc3346f0aa8c2f96a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a8d265f1d988456430d95f3255aab682682c7752303fb9592c8ee698caecaba"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ef3e415287b87dd83bb95aa23f773d27e8eed17da91354d61b4c6a5f3a1b6a8"
    sha256 cellar: :any_skip_relocation, ventura:        "d39f52fbf2d152719df419ba9ae34960bb1a839d034b6349a30a6af608a46b75"
    sha256 cellar: :any_skip_relocation, monterey:       "ce7f784f3120b030bff3a765c786693c8bf807b305182065dedc575184ee153c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "969a1a6e24d8bae84743414a57bc6ac044d18c4507d5507aad29fc65e99b0c8d"
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
