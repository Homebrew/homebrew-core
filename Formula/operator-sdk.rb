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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c7ca9d1a4ab5c89bc39bbfcc27d8036994d2d44f1f04462ba84d5b2563419c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1a655dc29c0a58325c63973150a53510ccbaee4201664a0aa2bf11f01f200b7"
    sha256 cellar: :any_skip_relocation, monterey:       "ef3064e6a9cd1bb2b1ea7238bf33839e0b123dc9d2c2a0030c2efb1816bd6953"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1be722fa2328d3f5cc151536f96c81b83a4959fdb4d4c3eaf657b5cef176d5c"
    sha256 cellar: :any_skip_relocation, catalina:       "07e98d1347f904a1a6f78aabb981b2fa635ef1754a1275c6830a616d18c29531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15d8c53758b7353893a0abe656283a203865d7ca01434b1c82ba699c1931e791"
  end

  depends_on "go"

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/operator-sdk", "completion", "bash")
    (bash_completion/"operator-sdk").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/operator-sdk", "completion", "zsh")
    (zsh_completion/"_operator-sdk").write output
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
