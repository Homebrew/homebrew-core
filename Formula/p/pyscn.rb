class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.24.3.tar.gz"
  sha256 "62c1b8d7d1173a704ca813b2eec2f1553ced3f25c008a59ff90854996417bbf7"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da05c9d404c39f4419257c400ec2c9d4e7e1dd26566defae177c3779a0bb06b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d13101bb844bfba22f42ccb22ea28f5858d97bb119b185aa2adb5911302c84d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa90e741cb5435b233de10115f681b2d8141be329fb03106355ec81107dc34c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d52b2b53212441b515afe7e8a7fbf359cc15a527dd15675f9950b31d68150a9"
    sha256 cellar: :any,                 arm64_linux:   "118f3abb6598d5a04a178d460c12591ac7c6b7c5389958001a6bd85ddca3c818"
    sha256 cellar: :any,                 x86_64_linux:  "62b9915cdeab083f46460730109e84d95fd87aea4579937357235edcbcc61d60"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -s -w
      -X github.com/ludo-technologies/pyscn/internal/version.Version=#{version}
      -X github.com/ludo-technologies/pyscn/internal/version.Commit=#{tap.user}
      -X github.com/ludo-technologies/pyscn/internal/version.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pyscn"

    generate_completions_from_executable(bin/"pyscn", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pyscn version")

    (testpath/"test.py").write <<~PY
      def add(a, b):
          return a + b

      print(add(2, 3))
    PY

    output = shell_output("#{bin}/pyscn analyze #{testpath}/test.py 2>&1")
    assert_match "Health Score: 97/100 (Grade: A)", output
  end
end
