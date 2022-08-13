class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.68.0.tar.gz"
  sha256 "b90f910579b40dc2ced544006d92649b0b6e30c150b286c1575be3f77c262586"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b22546d111e1512bca321b6bb1286771dab2041150e56b17de94c79e14d3849e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0468e6d0d082b25702ac7978f68c04c7ab1e3f8c29c343fc415cc82b99812a66"
    sha256 cellar: :any_skip_relocation, monterey:       "78f6fa082f4f4b4044dce305b3bb97e8aac13d55d7ce713c6aa7448e9737cf23"
    sha256 cellar: :any_skip_relocation, big_sur:        "030ece3a8f38eb792908d2e56c65f9ffdbd59cedb64a22bfba841be7745a905a"
    sha256 cellar: :any_skip_relocation, catalina:       "ee021764ed0d270fdcde63d83e6688024de0794432c4c4a33e9672031246a6ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9db165e9a8627d4e7d94ad3f1dd9defb7fac49f8bee3eafd4203da047e674508"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    bash_completion.install "docs/dbdeployer_completion.sh"
  end

  test do
    shell_output("dbdeployer init --skip-shell-completion --skip-tarball-download")
    assert_predicate testpath/"opt/mysql", :exist?
    assert_predicate testpath/"sandboxes", :exist?
  end
end
