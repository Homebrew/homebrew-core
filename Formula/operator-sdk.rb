class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.24.0",
      revision: "de6a14d03de3c36dcc9de3891af788b49d15f0f3"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7df07f7b2cc7bf97b5baab906b469c6bec5de9d723c0a33bc2a3c69cc5cc2aa0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02f0a2a0c715fd9569e2f3144de1d9831cc0258fa044cdcf00c1409bed56805e"
    sha256 cellar: :any_skip_relocation, monterey:       "4b769acf822f98e4a541454659cb1202c9077e3ca83dd0452f0385770f9ed1ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "45e58ea052df809d12a4d562d57cddbbb5825c90bb8b057231ffc8ed12a12c7f"
    sha256 cellar: :any_skip_relocation, catalina:       "86d89eebaea366db08b8ae082c42c2ac4b51ccd1a6f5321ade25301976263a4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23538f8e505917e4c410da28d476cf107f2f2e1987869bf2eba0a78bd7840bdd"
  end

  depends_on "go"

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

    generate_completions_from_executable(bin/"operator-sdk", "completion")
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
