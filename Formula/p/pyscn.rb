class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "afdb05b0c3f87c6edc1b81a191d3580d5ee335ea09d915c3e6a74ba9f2fc867c"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6442a96c09cf00986bf34658a32696c6f9391786050405677b324bb5d499729"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6081290fe37b56b4e8b497cbc725297fa27d382f02a8640fe3d4dad4bb1e3796"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61aa56af3fc3b28fa53571080f7aa6b62a87c1f1627aa58234d99895035c0bbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "173b6c2f1fb0a4f021468dc24e78556259e5265088d04c8abe39382c624a2f71"
    sha256 cellar: :any,                 arm64_linux:   "bae89cf8ae39cacf27fcfe79d2c63fefa587c8416be9a198e371c066b5b115cc"
    sha256 cellar: :any,                 x86_64_linux:  "c7eba48918127eaff735569eecf9dabcce0e1248252c3bf0d71203574aa51154"
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
