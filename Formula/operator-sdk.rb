class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.25.2",
      revision: "b63b921837de8dd6ce480033e427ecfc5e34abcc"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "494cf83a780e852487fa33e7f951d279eff68f0e726ed66f92287a81a69e50cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06df332feb22ebb880e38339d6ee2de4d00daeb339e0f48fa75ee7ec0377ef4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10ebf873db39facdca729344f99fd58a5de59afed9281c13744357d1c6787640"
    sha256 cellar: :any_skip_relocation, ventura:        "3147a90a205c52a6e1e56b71e90f9d1fdeac71b2d175c8b319105016589cf414"
    sha256 cellar: :any_skip_relocation, monterey:       "9c1041a74aa3cce9a1a5e8c13321d615b1d464e80c83d693226fd9605de32bde"
    sha256 cellar: :any_skip_relocation, big_sur:        "b785386ca5f66dee46f12f21ea76dfa982e5b7faf83fdebf92806ca90a7294e6"
    sha256 cellar: :any_skip_relocation, catalina:       "5b23ecf65951e4585e459673e682c3b94fc4d32c100d648535e9343f9c2490ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4c1ad04173ad197183d15d85833cae2a8e16c4564da6c906822086e80afc216"
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
