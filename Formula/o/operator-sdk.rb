class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.34.2",
      revision: "81dd3cb24b8744de03d312c1ba23bfc617044005"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11f6b734cfd3c4f56a3742ec1cd43d1f7e1081dcca5162e2f7615a7717610207"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f01eec8a402a1a168e17ec180671849d0d721373dd62e8f37382339847d02478"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91226d386a056d99d2b913dbf644f2c2b467d97c1602c6258f4df1baad505541"
    sha256 cellar: :any_skip_relocation, sonoma:         "674529dd2d331f6c23a927cf958cdfd1716a37222d952cf4a3a45c2f69b58c34"
    sha256 cellar: :any_skip_relocation, ventura:        "4bac4ab81994e05f96e06dc5f464635af99399e40028240f79f81593bcc3de6c"
    sha256 cellar: :any_skip_relocation, monterey:       "0ec93ee6f486efed46a26e36ce647c080da40f0a11e1f937cd088be729607b67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea8700d936ea71f7fd115c120d5049f31a8a093775635036688d4b1eb6081103"
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
