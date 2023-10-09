class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.32.0",
      revision: "4dcbbe343b29d325fd8a14cc60366335298b40a3"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1477ca58e6799f15cca3083676b28783da8ae9479f9d9c8a3f8706b02d7544c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3901f72f565488c36adb0f111f23db28a80a0d86c7e0fab5221b18dd052c953a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "013cbec55ce8a51ddf82a383694d8d59a8ab1d59a6da31c3d42c58c82b523f8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "78e81113e162439c05c47532457dd1cfd845bd70944c3c38c2fadea83baef2d5"
    sha256 cellar: :any_skip_relocation, ventura:        "7d0690bebcccd755fd61513d1b581cd873143a04e4b05407d5a98273d1115649"
    sha256 cellar: :any_skip_relocation, monterey:       "f33c5e1471ab63a07e7ba4cd4ac0a6db6d47e3e233ce2829dccf4954ace96fe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e00890a233acfee5a93d33abf2be44ed82fa0a37328b9809234a05d2576195ad"
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
