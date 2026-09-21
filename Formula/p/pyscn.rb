class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.32.1.tar.gz"
  sha256 "e63a1ed5c42d953ec2c40da341e897f2dee2eda44e70ab7a295d499523cc933a"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eae58a9d4f684a58e5b7091aba9c3ef3b57b94c28342c2a8f84d5722edf5dcde"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "900bb1d9500ed29c9fcec18e45c8867cd4e4a34e59bd74ae66acc0c7fe9f9480"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "89930e11ad0789e4d4b2c7efdc428a81e48a04ee9d6b01df1fdf3c24d93d524f"
    sha256 cellar: :any,                 arm64_linux:       "def852f9ccdb9d2646762745c56ee9b48adcf847198f4fcc2b687652fd22beed"
    sha256 cellar: :any,                 x86_64_linux:      "6612c8517121923984753d5deb8ae5d42d52135f1ccb4c8cdf42190593164a54"
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
    assert_match "Health Score: 97/100 (Grade: A)", output
  end
end
