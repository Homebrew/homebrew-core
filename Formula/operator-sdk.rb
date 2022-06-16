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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d63291e829df26505cc2492728e8b638a7c4791fd53b1304774d705f1b9105a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbf13b8fdc55bfa337fd2016b6f5f1dc09ccafd0cb4b68e6ee961809467dadfc"
    sha256 cellar: :any_skip_relocation, monterey:       "713c7d54ab95a8f4ef7184f0904556592a22f833c69aea62a4cb20af6f1c8160"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d238e974f8c19f52811f8cea2ab3341890f32bf07a11cf0da450a535ef4c804"
    sha256 cellar: :any_skip_relocation, catalina:       "a5d5812db32cba7b403d6ce6c95a66ce57cc5b2bc510476a0feae6986ca208ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "867c7ae50b5ce96014fb1c8bd8003a7b547851baa0ae0aee70a9e566348cae05"
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
