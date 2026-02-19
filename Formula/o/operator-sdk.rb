class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.42.0",
      revision: "ab5563df5499cafa4ea9d40d4b36b51899a4718e"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "292910e2303b1807abfd2e15f36239768aa14aeecc57e8c344f1d3d0225aebfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9016d1b8781a29b78156109cfcdd9455e8a462d73f96384dccca321e19e80023"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c80acbf5c023e2d17554f9a07388ab69c1c488763734cf06662b238a18a0804"
    sha256 cellar: :any_skip_relocation, sonoma:        "ada13ce55cc3cb321c796b393a29e2d102c4da57bc1878d96b7b9c1f2c272090"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe49bb3277029444d2a654cb0672c70718c4bff9439e27f87b7b95a96ff51b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cb1e0336db204954dacbf3fef72dd6b586ec7b23e024632686815e4ce59c810"
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
