class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.25.1",
      revision: "81b0a5e8c044a2e4be20f2d10d5161d249523c30"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8617d8f881e7ea2dbdc1d5e1f6fe932a3b7f7f596df1476d65f32f67c446dad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b08d96a2714e9531523055151bb3f42d9d917c82d94663a15b4740f3a1e75da"
    sha256 cellar: :any_skip_relocation, monterey:       "f461b3605ab0476b139cddc8c60ba2801a2b4f7777d94c6f5658eb519bb0399c"
    sha256 cellar: :any_skip_relocation, big_sur:        "40c4b0c0cf69f2a5abd4edb42b9a26216de69d8272e2408a86ea748633ae24db"
    sha256 cellar: :any_skip_relocation, catalina:       "4f07f0027fd0581885f5dbb036ddb6d8d7b9c787bc60057a76f6f8599da23df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46e192023a789467f2da0de90f993464324327a6fb0ccfb49a31b8c4a826db06"
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
