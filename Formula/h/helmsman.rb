class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "1fd57af9978681f0c148157e5ef7929b5154e6e79bc13c41711892340320254e"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b083ce72a651f9040fcd994a3c2472ea05689e460a1837d793ddd2fae40800ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b083ce72a651f9040fcd994a3c2472ea05689e460a1837d793ddd2fae40800ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b083ce72a651f9040fcd994a3c2472ea05689e460a1837d793ddd2fae40800ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3446b60d03f301e50972b2a38239cc0ffe0a0052bef78ecac9cb892aeacb9f3"
    sha256 cellar: :any_skip_relocation, ventura:       "a3446b60d03f301e50972b2a38239cc0ffe0a0052bef78ecac9cb892aeacb9f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d40bb6b1568328e315a28aa502c5cbf8b86cb95f493647ff4edd639878f7ba1d"
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
