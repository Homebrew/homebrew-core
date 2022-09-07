class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "6dba28376f3016e49a597d1bb3b9365cdd5ba5cd6e21c848e1c97dca49d6bdaf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33921fe24e6a5a76237f0573a9c8e54717996a6b7c7641a473aea9916ce28c0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9052dedc3561993007bc0fe3731b386de2cf471fceac2922064803dbe5f15e22"
    sha256 cellar: :any_skip_relocation, monterey:       "bc4e4a559e5b885f509fb34c4692e128223a61c178f460cc72b6d99d45d6ddcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c2920bef09a957f8e88c946ee1db5383c79ec3bdcbce869b116b87f59344508"
    sha256 cellar: :any_skip_relocation, catalina:       "8e138ba3111e43f0c0e018b40d7b59e31b3e73e346e51d74aa045144586e5de5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c5d31562d925aff16061f68c78e8ab2d9410c4221417ebb950aa38a194075f5"
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
