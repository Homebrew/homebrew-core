class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.162.0",
      revision: "06acd0c7bcca9b7430f749da4f76755150b96d99"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92d0b1becd3296594660a8339fe0d811c3f05c52692a9cf17c07e0842a3149db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad06f9423f7735d1b895237fe77c241e3f7c7e52aadef8223c64689c87607905"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce60d8ce15b2222471f612bd094c388bd21eee94f6438ab2d270dddd6a77830f"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb9ac75e1abcb916b165e9778eeb7cc5facc069e0fb6c80ea615fb9058181894"
    sha256 cellar: :any_skip_relocation, ventura:        "1aea6aa6dc23f1cf83a4bd844ae0ddde67d2357ee7bff257524eb23fb91895dd"
    sha256 cellar: :any_skip_relocation, monterey:       "b0107215e2cc5ec160071c9402bb0cb4e8df752649e6602e6ae521df3834ed35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d561c333efb5ef41cf5feab8de04693123f3108f12a610244f16e47ce763a69"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "ifacemaker" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    ENV.deparallelize # Makefile prerequisites need to be run in order
    system "make", "build"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
