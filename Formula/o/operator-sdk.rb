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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee180a4e583804440cb95f410b9eb164becfb9396ce5b1f8514610432a76b6af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0355eb6ffabcc0b00d8fc44337c574b7617b17ef6dd06e8dd7ba4d75b2be9241"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b84f2c2b5c1f37c8c9aaedbdd6d81e57010c9c64e6318a9d4b7f335f76dc15b"
    sha256 cellar: :any_skip_relocation, sonoma:         "10588a890073b8adba6341f0989b74ed973a715bea7db99dc276eb5d78c366d1"
    sha256 cellar: :any_skip_relocation, ventura:        "b47bbcd9346383a75c08e7435f2c70221c6cd69f5f39f7ad7bc1d21a547597e5"
    sha256 cellar: :any_skip_relocation, monterey:       "78c2b7e7d97e57956eeee393414de573fa018fc967191bb6c34f089b5043a98b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e8d51713b7d920b6a536ec87ef6f84cbc02fba4b3af2ddafbe120b8adbcc316"
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
