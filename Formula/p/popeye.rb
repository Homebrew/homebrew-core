class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "f315efb2d4075bb8ada297e9c8f1b4ee408946224be9aa38d374350a03c58ff9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d6eb4924690eca123282ca54fed77c7359fb89085474b1e2fde6909b3b590fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d5dba8afad6f9ec46239a5a9d90a95740bc944f9e235e59dc4cd4936b79125f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db6e4fce3e200acd3bcac97bf48f1006d373e82a81ea3eeda5cfa80f1fcb15e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca0dfbc0596abbeccf639581d976b541723334063dcc66a979e48701e94ba334"
    sha256 cellar: :any_skip_relocation, ventura:        "4c1540023630f0a53e7f169b143af9b095774418da7e94007530eb33dc1c8c3a"
    sha256 cellar: :any_skip_relocation, monterey:       "4b46f582a04409d81ea6fc48c315fa6be4875a33cd979e53624708e85ac476e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d3d7e8deb660249e0b490fcd75456c5c7305d545bee323817a16c472f329ed2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"popeye", "completion")
  end

  test do
    assert_match "connect: connection refused",
      shell_output("#{bin}/popeye --save --out html --output-file report.html", 1)
  end
end
