class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.22.2",
      revision: "da3346113a8a75e11225f586482934000504a60f"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6e48a2616b66e6107de5daa3bdb0d68bdc06e618ca7771b93c367335eaa93d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "566a7ca45388bac23b8b1a19a06a636150356872c7d89cc1aeb367ffd481ba97"
    sha256 cellar: :any_skip_relocation, monterey:       "8946183de60334f8b506e085998fa259ad6879bb1a912e3a2b32e508d0d648e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cd4468c635fbeedc682a2ca011655056459969e1f45d70875f2f0cf1e44fa57"
    sha256 cellar: :any_skip_relocation, catalina:       "d8a589c2d4acff6981d14e3a1c1eb56d2932123b29deb89d22829a37dcda99fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38b62d9aaa15556248c22c8bfddd4bff17f5674413543302c5dca34e32483dbd"
  end

  depends_on "go"

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
