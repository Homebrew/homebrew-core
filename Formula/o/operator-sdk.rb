class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.33.0",
      revision: "542966812906456a8d67cf7284fc6410b104e118"
  license "Apache-2.0"
  revision 1
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08b3d9df0a06e1d2b1f842ed024a71099aad0601d5ce2c78df0d2d3e008f0df5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85ea3675b65ca697028fe0d057cf0e1101d4e23dc754534f69762c290571f3c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dfb8c8d9fa2b873cdcf61102e5722965c22c6ae31b8070e5faf1992455216b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "cab850875014cd719382f21cd4525a056e13f9f4c3c25f7a987182577ca21e38"
    sha256 cellar: :any_skip_relocation, ventura:        "0781599387c96b14a8a6c3ac5bfb6ab7c6a80234524d6627c12ae616b9185ed4"
    sha256 cellar: :any_skip_relocation, monterey:       "ddca03df191a7830a8cfd915f62299d684263a2fecf0b9346906ece45706bab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4ac2b9bd38500aaa85e4b675d011c4bfebb2879e765b3e17fe351bc9de3b9d9"
  end

  # use "go" again when https://github.com/operator-framework/operator-sdk/issues/6644 is resolved and released
  depends_on "go@1.21"

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

    generate_completions_from_executable(bin/"operator-sdk", "completion")
  end

  test do
    ENV.prepend_path "PATH", Formula["go@1.21"].bin

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
