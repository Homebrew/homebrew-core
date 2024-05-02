class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.52.0",
      revision: "f778ee7a6d76ee22c4cc6dc8fb809e27248a704c"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fad1dfda1783ca6322973d106988343679c2679628e2491058a04657aab86c9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c8de5bec0fd7949bb5ed0570356ee298fcca257ce058876f4573dc17571056a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efc6ae9085cadd7bdb86fdb07b431e308bf2d2e51a47a522eaeee7984c0ac5ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "92ac2d890646270c34d58abec0b9a4e05aae8578397719021f011e86ecf42ea4"
    sha256 cellar: :any_skip_relocation, ventura:        "b4dfe3a2aa69219f39c4590a6d4c7aebe1aa91c044ca916635f7a3279b42962c"
    sha256 cellar: :any_skip_relocation, monterey:       "fbdbbac380559ca29e33b446f420c8004b6d0fe91decb9bc24a6e560a3e7790c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a402c766d73efc89fe88db74a5dc2abe904612f0453df1bfdde9fc46002a677"
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
