class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.25.0",
      revision: "3d4eb4b2de4b68519c8828f2289c2014979ccf2a"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f829ae5353ac163794bf51962db13804295ea0f4384cefeba0f70547b7d71d1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60d9bf1ab930e4bec6487414f3b1405c2062867a2e967d019ba471eb8dfb9c67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f12f893a3e88a0062010a29517f006dd7cc086ab57197e06153c67cf06c612b9"
    sha256 cellar: :any_skip_relocation, monterey:       "2e9663a1367f6ded7128da3674f72f5b733c685f55cf63b841b4b747dbf83b7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6618cdba4e628c8f3b1443a38d82483aba223b8b79f5f7d2930235d38b7d0b6"
    sha256 cellar: :any_skip_relocation, catalina:       "e3e28d8efc72833866cb855079da28172b0c9d2d8367ac0b8f608aca8e061aed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "415e69156ab82733a7ec6d8ebcbc90005793a673339d4f3f0296f5d6cf3a46db"
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
