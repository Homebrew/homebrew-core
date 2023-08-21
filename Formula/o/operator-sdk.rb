class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.31.0",
      revision: "e67da35ef4fff3e471a208904b2a142b27ae32b1"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "927ea201603095434ca0b8de16185b4aaf8ff95e97fe08cb2d7637cd43914f86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3adff7c45fad3c225f4e2e75445817c170e6e299025ff42be12ecfbf2f0ac4c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d97e0c7e14353ee92a15a9395d65687bf419914ce24496e86f35198010da330f"
    sha256 cellar: :any_skip_relocation, ventura:        "64cfc467be846da7d409cbc3941554d8d841eff148c9cbf0c294892f69b6f893"
    sha256 cellar: :any_skip_relocation, monterey:       "16f989ab91fe6c64975727d0c53a718665ad3243022c36ad29862464a1a6b051"
    sha256 cellar: :any_skip_relocation, big_sur:        "10004e16739401e6acf5245ea4067c2015202a1efdd81985f9f8141d09bab512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e84790ae45a9428ee3c75c22dc14b5f6d02431c20c0e1b260602f44caa71978"
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
