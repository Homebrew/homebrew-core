class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.30.5.tar.gz"
  sha256 "3861ec99ecd8cecf93993fe6d1e4d573d2e615ccc930763cc7314ca23242bcca"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bc06f38e4596f4891237728459f257e6a36a189884cfd40f253a0bf564208daa"
    sha256 cellar: :any_skip_relocation, big_sur:       "8820a72135d535a8862334c00a281322061ca521b71e5ae8d64ac50256318aef"
    sha256 cellar: :any_skip_relocation, catalina:      "fef494b90fe5d5f50f6bba3242d268cb3ae3be2023f0d50fc5559b5b777e43a4"
    sha256 cellar: :any_skip_relocation, mojave:        "c5238caa35151072c9f2e7cf158f313144cf75f4659739aad39916c644587767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0123f074b453a513384642831605ac55e05c47afa216c0e39d68ebf9a0c845af"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    on_macos do
      bin.install "bin/darwin/newrelic"
    end
    on_linux do
      bin.install "bin/linux/newrelic"
    end

    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
