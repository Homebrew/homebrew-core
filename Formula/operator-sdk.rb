class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.24.1",
      revision: "1a1c56f7d0c7cfcc16e1ff2140caaa6d831b669b"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "894290310ea19acc34524d11b32c739310aba16f702830b1ed0bb899f371968e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a694e3c87bf6965f66cf68ab7afd15db6ba14ba93fb1f1f9d6a72f78e93a0bc3"
    sha256 cellar: :any_skip_relocation, monterey:       "e0fb629cb2b3fb5bcfa217250754eb60b7e666a698b1c3992e8736c2e5ebfdb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "692bd243ba275c07f6506cc10dfe0fe0e593ba1c55df91ea835e6a6adebd93e6"
    sha256 cellar: :any_skip_relocation, catalina:       "b47551237027522fbe3b6a536c173a6a9272af72b862a988c714d71035733efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9b82ba519c35ac9caea8464762da38eca6c76a50736ba487819d457cdd6a8f2"
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
