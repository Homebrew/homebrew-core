class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.39.2",
      revision: "f01ea5405979ab9ce7049877f9a0c23927ccb2ec"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3f6bdbd5c2f859d6ede458c91159e9f613f82c9032b9b1fa008966022bdf18b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43813b6b92a0d5cfa17744dc0d5561d88a1172506042f92a42dca10a62319489"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bfe47acd143c07f4646ca9fa8b97787d1994a2503b8f1f1c90def180789ee3ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "223cfe0f8cecbc25ec416c32abf50dbda9e473761b5c7049c07bbf00fd9f29dd"
    sha256 cellar: :any_skip_relocation, ventura:       "c13d35cc77513c33496557eae537ce32322c53a14c2beac2c98158f50f6b5fb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "509d069ebfcfb21a8d8aa096ac3b7dac5fd261bd0a04c4b0c6f3080ec72a4526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50747c090a3153b7e2d2604b66870551c4a5a5a0496c885d7c6dc1dde3d7b12b"
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
