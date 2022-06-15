class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.22.0",
      revision: "9e95050a94577d1f4ecbaeb6c2755a9d2c231289"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f32c2fa762bf7c141304cceb3a8f510078cf633bd7e5ddd86ff570e7efae1223"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "330c6ba8fd9a4fa091bf60bc5df1d0f968da34ee590723513a7517fd603d3bfc"
    sha256 cellar: :any_skip_relocation, monterey:       "41ddee3b32cdf91fb6081d63da4f3a9c4c5bb1afb5b4c28870c0995b57339a59"
    sha256 cellar: :any_skip_relocation, big_sur:        "205761199e8dc836e80ed2671d0340f8eb04efe30aefb624a39a1ba3c9daf3e4"
    sha256 cellar: :any_skip_relocation, catalina:       "1b6e953328a9030d4a45d377bdb47ae27d5d9fc5e3718cf073327e1082c8fd29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "597fce6f6cf96f22c5220a52d05355eb30a976d64373427b8de772de7202ee7a"
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
