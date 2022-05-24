class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.20.1",
      revision: "1780d438cfd87382d034c72703a80d9073b7b6d8"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d5cd01b5fdb8324fb44bda66242e6a073b215b97c1e3bae784c63f425ad7c7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae3bb5275c923c0c665db28ab637705d9c8df340caf366de30667ed688dfadc9"
    sha256 cellar: :any_skip_relocation, monterey:       "2eeeb399d7d9efa353efdd8c498d99d7714c3fb55dbc937f7ed6cba6d3b01328"
    sha256 cellar: :any_skip_relocation, big_sur:        "85d9bbc2e01b77b932e13253becc33ee1b8fb84c4f8dda91e95b78bc9ebe3bac"
    sha256 cellar: :any_skip_relocation, catalina:       "d52fa5df9d064f3bf51c06d8644ee5fdafefa4cf47d47699184b8d6e70cfe678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d3f8c7cdbe90eb140988a13064c9725f810e2c301ad8f3cc51b5f4fd865249b"
  end

  # Resolves upstream issue: https://github.com/operator-framework/operator-sdk/issues/5689
  # Should be updated to "go" when the following upstream issue is resolved: https://github.com/operator-framework/operator-sdk/issues/5740
  depends_on "go@1.17"

  def install
    ENV["GOBIN"] = libexec/"bin"
    system "make", "install"

    # Install bash completion
    output = Utils.safe_popen_read(libexec/"bin/operator-sdk", "completion", "bash")
    (bash_completion/"operator-sdk").write output

    # Install zsh completion
    output = Utils.safe_popen_read(libexec/"bin/operator-sdk", "completion", "zsh")
    (zsh_completion/"_operator-sdk").write output

    # Install fish completion
    output = Utils.safe_popen_read(libexec/"bin/operator-sdk", "completion", "fish")
    (fish_completion/"operator-sdk.fish").write output

    output = libexec/"bin/operator-sdk"
    (bin/"operator-sdk").write_env_script(output, PATH: "$PATH:#{Formula["go@1.17"].opt_bin}")
  end

  test do
    if build.stable?
      version_output = shell_output("#{bin}/operator-sdk version")
      assert_match "version: \"v#{version}\"", version_output
      commit_regex = /[a-f0-9]{40}/
      assert_match commit_regex, version_output
    end

    mkdir "test" do
      output = shell_output("#{bin}/operator-sdk init --domain=example.com --repo=github.com/example/memcached")
      assert_match "$ operator-sdk create api", output

      output = shell_output("#{bin}/operator-sdk create api --group c --version v1 --kind M --resource --controller")
      assert_match "$ make manifests", output
    end
  end
end
