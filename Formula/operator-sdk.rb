class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.15.0",
      revision: "f6326e832a8a5e5453d0ad25e86714a0de2c0fc8"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dcb4e629a43c80a983c2829404e2c6bbea0655ef2a40a7d62b9daec7cc2cbb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0a370d7ddf24d39fb6140b83522dac88d4ba245e48f298d8320022ef94eb874"
    sha256 cellar: :any_skip_relocation, monterey:       "77fc14b02c369f3fb164b6fd0c0e761d9cdf0bd8a28a0a8a4d185eb1b1ebb738"
    sha256 cellar: :any_skip_relocation, big_sur:        "af4e6f3ebe8d56ec10cd6bff8f4cb3773978f6f1f185743f38c8499c4bfa8b78"
    sha256 cellar: :any_skip_relocation, catalina:       "9538111a445a5bfbba21e5729c2de8461735bb733c48110e1dc2b636296dc812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aee130583f9b8d4c230dd5ab44be0dfe4753c63f19ddca615258027cca533468"
  end

  depends_on "go"

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"operator-sdk", "completion", "bash")
    (bash_completion/"operator-sdk").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"operator-sdk", "completion", "zsh")
    (zsh_completion/"_operator-sdk").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"operator-sdk", "completion", "fish")
    (fish_completion/"operator-sdk.fish").write output
  end

  test do
    if build.stable?
      version_output = shell_output("#{bin}/operator-sdk version")
      assert_match "version: \"v#{version}\"", version_output
      commit_regex = /[a-f0-9]{40}/
      assert_match commit_regex, version_output
    end

    output = shell_output("#{bin}/operator-sdk init --domain=example.com --license apache2 --owner BrewTest 2>&1", 1)
    assert_match "failed to initialize project", output
  end
end
