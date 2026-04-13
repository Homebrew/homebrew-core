class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.42.2",
      revision: "6001c29067051e1a04e829ea033988b904d1845e"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ac26f6202124cd135687b423d478d65c0ead0ac1178a7bf294db5a0697642f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7cbc9ed59f8c33306bde4ba2beb16c3f8c4e305c989e2b3c71d663a0f70289f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e44d4197872ea85c600c9249019a527fb2921015b6f6020ccb9498f7c628b82"
    sha256 cellar: :any_skip_relocation, sonoma:        "10a7169afc5dadbd985d6d679ffd0c7988691769b3e84bf11a51db8c837ce201"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8da9980171416c190a7f425c8842e983eae4d003827b6f1fa3560fb061952ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d713a149a37d45a02d8819c1578ff81f2fab470c58db46bdfa529e2f590dcda"
  end

  depends_on "pkgconf" => :build
  depends_on "go"
  depends_on "gpgme"
  depends_on "libassuan"
  depends_on "libgpg-error"

  def install
    ENV["GOBIN"] = bin
    system "make", "install", "CGO_ENABLED=1"

    generate_completions_from_executable(bin/"operator-sdk", shell_parameter_format: :cobra)
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
