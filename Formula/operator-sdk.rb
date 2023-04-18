class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.28.0",
      revision: "484013d1865c35df2bc5dfea0ab6ea6b434adefa"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3965bbdaf136a85fe80ce5fc22b0052a4372fb2618c793e568ba6020d680a0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "013ac58b498db97b621f4d4eea650da900da2402966d845c0bb812d34df8d776"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4a3c4b35f6d3a8b9d5ce4a3a66c9663cf7f0f8a49aa7bfce87407b6ed0917f9"
    sha256 cellar: :any_skip_relocation, ventura:        "fa4bceb628cd031b5a714d2148e752546b46292f8004b1037e23dd0c59d756d3"
    sha256 cellar: :any_skip_relocation, monterey:       "8b3d0931156c5d889d20673f3914d939ee4b028238a0dc074742ceaacd725e3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b96e8f19d412cc1227d24d69c63f629870f8b8088820192fc9988034818a53d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "069a73bf64a7112fc11eb17f4a78dfe7d9ea9ecef115a33eebbb42797ee4dc28"
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
