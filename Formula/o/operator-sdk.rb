class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.41.1",
      revision: "69ee6d4077ff769a8513571343a96f3cb8ca35ef"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7af87d45d23a38bdd577d79113fec7e13ed85659b08370840cc4330e9a1f522c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a56c33d80094de249513a5357106cfc05f171c4a9fcbd9d716958c025b3af00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71366694c1096f6f371093719fba04b8169c048c38255c1ef28aefba17de03d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f8c7d8a716e12d7cedc8da2b7803618f54b4178dd6bc3db1a5409f5084d996e"
    sha256 cellar: :any_skip_relocation, ventura:       "17a5045f3c546d858044a904d97af2275f0a15f5069342430f71f4bcb9450dc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7d5e4e0838f3ae5941a419343a3076d0ba2e37d8f579fc365cdb36aafc76529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "570ebcf4795769e4865155dc8500b15c4862535e0249f51396bc2234051ab532"
  end

  depends_on "pkgconf" => :build
  depends_on "go"
  depends_on "gpgme"
  depends_on "libassuan"
  depends_on "libgpg-error"

  def install
    ENV["GOBIN"] = bin
    system "make", "install", "CGO_ENABLED=1"

    generate_completions_from_executable(bin/"operator-sdk", "completion")
  end

  test do
    output = shell_output("#{bin}/operator-sdk version")
    assert_match "version: \"v#{version}\"", output
    assert_match stable.specs[:revision], output

    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"

      output = shell_output("#{bin}/operator-sdk init --domain=example.com --repo=github.com/example/memcached")
      assert_match "$ operator-sdk create api", output

      output = shell_output("#{bin}/operator-sdk create api --group c --version v1 --kind M --resource --controller")
      assert_match "$ make manifests", output
    end
  end
end
