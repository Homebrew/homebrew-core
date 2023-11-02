class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.48.1",
      revision: "1242f680d6b12932f6dbf80994d4ef7980866e71"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e694f70a633860a182bd8abe8af02bf92709be1502c7566c20fb07db27273689"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f2130a8d7aba43f0947a0e97e7ff3e05f4dbf3f3b8466db742067d081c08051"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c120e5a66ed7dc7474318f52dc19692d9835ed92befbadbda22d6e60cc2211b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "44e2926be261cb11964c74ab18acee0ebe25521a5d8a594f549ce857591fb02f"
    sha256 cellar: :any_skip_relocation, ventura:        "baaf75ef7d7a92572e7310d7efea2bfed6aa77ea36bb1c2cf839ef3ecbf93a19"
    sha256 cellar: :any_skip_relocation, monterey:       "664d08cedfe75902704b6b76c54fe4333f541393244935002237b73bd40b549a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "155cca4e87e833faf254854fa006b3bddafad89ff03e51ccd19d620b4e02c56c"
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
