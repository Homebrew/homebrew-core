class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.39.1",
      revision: "b8a728e15447465a431343a664e9a27ff9db655e"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c72756368f36b5db87a513941da50ae1100a41a886676af0b302afd1252bd641"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31860b2621cb4b62b83ef2602db28d489c18a583c69015efef6d14d64d666cd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bcfc6f7a55a7b318ada9310369f2f52753b90c0b0b3d7d567871fc260a71b6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a311c362a20044715e8db48bcf5bfe74819b2bf569aa99e81781243d57d926de"
    sha256 cellar: :any_skip_relocation, ventura:       "7a436133698820e371a0c3f12b10219401b0ef0dd8a7bde78367e119d5fa0876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd8ce5b23a2e17a939608fcb5d396b36192685902c6b36ed69d833f5d3d527af"
  end

  depends_on "go"

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

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
