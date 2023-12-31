class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.33.0",
      revision: "542966812906456a8d67cf7284fc6410b104e118"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08bec6a42baaf146bd580273529b575c534caa10681b91c3a2185d1cee95817e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93aada0823fd349a42b138b7aa347511af1642ebd82f9287b366f80de5425ba9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33ec046b6f4c16cafc46a615e57c2febd61d986592bc15cc876162f73a6ea637"
    sha256 cellar: :any_skip_relocation, sonoma:         "923a526edabc339931f16181c511f42cca454143d166e6a04c3c4a39aa4702a5"
    sha256 cellar: :any_skip_relocation, ventura:        "b6670b0de16cf9569897f8aec66bca3ef73d5fcb5d8eab1a9880befa3abc8c4d"
    sha256 cellar: :any_skip_relocation, monterey:       "5daf8bb5d05cc376be6b6ce6421fdd92b608537bb6a79a175891a2d2eb54ca40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1e03597383084ce8f01d276d922bc96b01fd3865abb1801f71d8e016d06ebbb"
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
