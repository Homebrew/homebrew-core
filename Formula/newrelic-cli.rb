class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.19.tar.gz"
  sha256 "63b13457a363d4b17773f0914105cfb298ebdebb586ad325434c892951802b7e"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e52cf86c32bc5b6835bcce91f861f9b0e99673ffe45f1bac22d168edf5bfa29" => :big_sur
    sha256 "211b7ba244bccc38753db2f539ce50d90139f4ee3140f2bda09eee89d0337e54" => :arm64_big_sur
    sha256 "43e8efa8611008e84564c8ba20b45ab6c2a6e94cc2496e2182b1cd1c0f443f89" => :catalina
    sha256 "da83eaba909720b940bd7e33f3d0d3c1a68718aceb5add85beb6f5cb6ce79530" => :mojave
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/darwin/newrelic"

    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    assert_match /pluginDir/, shell_output("#{bin}/newrelic config list")
    assert_match /logLevel/, shell_output("#{bin}/newrelic config list")
    assert_match /sendUsageData/, shell_output("#{bin}/newrelic config list")
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
