class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.36.1",
      revision: "d9c6f5f86b23b3bd7f3ea9111bb5886ba5156d83"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "666e287a11c50cc229fd2f4deb4212a422e33a5cd49f812e86d1e3df42e49ce0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b853abfb58d61f226a99a27019e3cc524f9043b3f32dada012879decf7986c64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "335b54c7845198c2f5409b45fd1706e87beb4511145cd1db60aba75c34fcfa15"
    sha256 cellar: :any_skip_relocation, ventura:        "efa63b2b0e25b38bfce538408f1f2e91f08bb8ff0c9a39122c089c6f59dc91f7"
    sha256 cellar: :any_skip_relocation, monterey:       "571a763d44b29fed12c06736f93edbbfde49f270bdc0d20ca74795d8371a6a95"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecf855c7f3acbaad860d4ebc4e1a1e2b80ed1eff0c4f7ab2b44b566c9b8fdc4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa12211728536a16c0e8134f5762e9696e8cb235564b5dc2238f382796c90e4f"
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
    run [bin/"newrelic-infra-service", "-config", etc/"newrelic-infra/newrelic-infra.yml"]
    log_path var/"log/newrelic-infra/newrelic-infra.log"
    error_log_path var/"log/newrelic-infra/newrelic-infra.stderr.log"
  end

  test do
    output = shell_output("#{bin}/newrelic-infra -validate")
    assert_match "config validation", output
  end
end
