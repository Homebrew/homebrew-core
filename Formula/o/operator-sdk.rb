class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.34.1",
      revision: "edaed1e5057db0349568e0b02df3743051b54e68"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7b45852070ba2b651ccafa070c30e80976adb0959e8b10264b6ef3f87f7601e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c68acae64499125a003a9293d54dcfe748f289f660107c0ad0305252bbc54ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0457ff91e01660c2a8ab699518f8ef7a220ed1d63a8cd273aa724017f6c7e45a"
    sha256 cellar: :any_skip_relocation, sonoma:         "98ad3b70cb9e5c14fc85001a08ab6e3dafc5da6e312acd62b2d4cec5f9ed6cf0"
    sha256 cellar: :any_skip_relocation, ventura:        "c27c851291a3b086252c04da4b8c4148e83340d07bc7c7e0299be93c9a18252e"
    sha256 cellar: :any_skip_relocation, monterey:       "251f89b903944735d88937d5e19d01e50f282a0e42958797189c885797c31e2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bde602e2f69b8f8af5466f6274d7397ba9d9606c809557ecad062305de9ea1a"
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
