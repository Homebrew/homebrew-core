class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "f91541bf07b9bee4167710dc3d68d682a7bb1b696de86d9d25fd1e4990b63a05"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2dbf4202e0e2991d2e52495fbe77c532827b25036f2d3347d7214b6df566c72f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ef88d3d6f5ce001d2fe5934bb6d05094cce6586993df16e45f05a4bbe36556e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abf27d884dff8e5a1f1b84b11d2ea9ceab51faa724c3e7e2168b40b3f8bc408b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3e8c05a73c0ce3a65a0941e0bf93e6d2dd43ad994a5030813d94772b39c7f9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce786f71b84aca5031ecde6de3fd9567646f06dd1a39ffdd86d2465f86bbd75f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56842bbff851c9946cfab4b9e5080d023399576217b117fc7452e3c9778cec5a"
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

    generate_completions_from_executable(bin/"pyscn", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
