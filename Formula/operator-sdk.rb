class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.29.0",
      revision: "78c564319585c0c348d1d7d9bbfeed1098fab006"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41a79000504f62a0507308cc11704bd12755d27892eb232e7bc2676686294569"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e0ceaa6048f583f39de5473072663653539299807171d7ecf0260e81805df33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a382c706b0f1d1ff23a637cc99e220c5a7027cc7dcb01631780d199065dadcd"
    sha256 cellar: :any_skip_relocation, ventura:        "1bd91f2e6045a7e6ed03ff20b345b3b9a291b568ebb19321f416c5c1362c05ad"
    sha256 cellar: :any_skip_relocation, monterey:       "0a8b64470441fe377acc6837ecbc2444f3ec509531dfdf1afa30ac4c867915e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f95d373ba3bd01227c42f1eab5582b1f3b98410aa4eb0c1f9b298643da9933d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "912d0b71b49a7fec240ee7dd2fe3865b2ddcfe92f877228cae35872e23c0c3d1"
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
