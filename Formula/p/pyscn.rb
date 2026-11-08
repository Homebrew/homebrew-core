class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.33.2.tar.gz"
  sha256 "8d30b2d41e0f7506a0758cc688b6f92bbe0bd01fb854edba8ff73459184aee5c"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "36461a2670442e4e6350f5acfe80395dac578d142a045d34acdf175322fd760a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "63a9e32dbbc1afa5ad8254e13f2fdbef3d7975846ff13d8ce924e27573b65ee2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c232803816b53671aaa7a393c4ed83488a0c0e2ff0536ebc938d9ddb32c7e959"
    sha256 cellar: :any,                 arm64_linux:       "0d5e8c4ba6fedb43db33c6bf95087c39dda0fc1befd4af5916f541eb4e60178e"
    sha256 cellar: :any,                 x86_64_linux:      "3b84e9b51b0fc9b33ccede92b31315854474e9343726bd54b254b77b42ca7505"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
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
    assert_match "Health Score: 100/100 (Grade: A)", output
  end
end
