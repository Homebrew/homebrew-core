class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman/archive/refs/tags/v3.18.0.tar.gz"
  sha256 "d1c54df207ae876b9e2a1a77cfd703d450871a8d516c5e88baa641c2ca847bfb"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2de3885cb7a17b827660373aa92fbe109be6401057485089181452dbda7fafd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2de3885cb7a17b827660373aa92fbe109be6401057485089181452dbda7fafd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2de3885cb7a17b827660373aa92fbe109be6401057485089181452dbda7fafd"
    sha256 cellar: :any_skip_relocation, sonoma:        "539ad1ff618e53f3c159aa2d79e5c6f7089af120747ba55d35174a9cf497ba54"
    sha256 cellar: :any_skip_relocation, ventura:       "539ad1ff618e53f3c159aa2d79e5c6f7089af120747ba55d35174a9cf497ba54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3244639ab2f71fc1507f9f6d95b0bea56b33c37f3ac5821059e38a4d211f4669"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/helmsman"
    pkgshare.install "examples/example.yaml", "examples/job.yaml"
  end

  test do
    ENV["ORG_PATH"] = "brewtest"
    ENV["VALUE"] = "brewtest"

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff not found", output

    assert_match version.to_s, shell_output("#{bin}/helmsman version")
  end
end
