class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.30.0",
      revision: "b794fe909abc1affa1f28cfb75ceaf3bf79187e6"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36e3e12a49e6730987a28ee014043296ad4e79d84a31c31bb2c509b57cdace94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50803b4f6ecb0a122f4f908ec5f4b930be9f8cad246a4e4e45465147d7e34cd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3cca258fe0e82f3e29b808998c32718661f1d05d86cf37acbf0f51ed471d79f"
    sha256 cellar: :any_skip_relocation, ventura:        "d0b35a250f8286dde3a1ed8341a31c8feea44592e259beedaa2200d841def001"
    sha256 cellar: :any_skip_relocation, monterey:       "8fe24817c741c41b409e41dfe7686b1915a9bf87a8e4d944bd80c22c83de6a41"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9dc74783f792dc96da3c9630d33daef860f813144fe7bb3bc1ccfca8facb29e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1dcb7bdf99a4d8467ff84a03e8a7d5537b90fc617ae3dce9af739468d1100e5"
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
