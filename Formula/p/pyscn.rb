class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "fe371cea116bf6d15cd3616a7845b201ca257f6818219d91f73ff7a6255c3e44"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edf72bd11528e6bc74c68096cbcc16318be50b720db58e0d4640fdf04c2a9b65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c95a125e8aebb564d4f2ec8978fb815e2818895e4852a854e8072213c9ae909"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b693285df203a4dc7d4d123940cfa160563a1dc4c74f85104faa213587faebe"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6e1226bc14e636aec18c0c340831fe1d931f6851d42530f7cadf2222fc2427f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd75d7ee77c8c871009d62759a3d5715395a312e2dcf7a936a28268f5149f194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a8a99785f89d515ee74eafd34404965d690c0be09c0ca5bc6ade0b741338f47"
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
