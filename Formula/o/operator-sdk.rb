class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.42.0",
      revision: "1b9cb8dc55a83d027e562d81dcb134ebc8700ba1"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3849b980fcbe3174aad5d5943de80a2ccd8f38563e9b612f9636050486ac10a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2191d393bd79a01af24821ed094747f48216b95acb2fc84bbf421ba426b559e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fb75fd97ba04adeeb63ab4158d1e4bfa69e51e7dd425040d0254edeb2c065be"
    sha256 cellar: :any_skip_relocation, sonoma:        "96b1589c9586b887f9c63e90dc64474f3dc1fb8eda3bf7a44d207348c2cb08a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ced779ec9e0b5b7cf0d8276109af98f03e37af69a99ab4cc7b5bf6ef86f1982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02a7714ccd75b2bad79db9955e787aaa97da63103f527f5aa0acbd71b8ee8267"
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
