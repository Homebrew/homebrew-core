class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://sdk.operatorframework.io/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.25.0",
      revision: "3d4eb4b2de4b68519c8828f2289c2014979ccf2a"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "403005375b0b632b0cb676c9a96b0f1cba73efd82bf2a47dfc7010ce7e777cd6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b69e6b856d151a208c90cb84a958544467a89d55d26c10c6f41887b4f862c1e"
    sha256 cellar: :any_skip_relocation, monterey:       "0136bee34a40e1d055fb869aaa455b4b051626f8fd2768389075328e8df1b3aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f7951e4484b81441e8808abfd25059ad1adadfb6e1879dd800dcdaecbfc6d21"
    sha256 cellar: :any_skip_relocation, catalina:       "fbb86ff06c4837ca2ba1c7cc0168096f0eded25dfbda5a194d5069d80c5103da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a27efb0b46630d2f4eb47aaa5d001373876f99170a4ea3699c076c58dec76748"
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
