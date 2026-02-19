class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "1252bfd2e91994d7122a7e1a78ebab31c610b52478f034b73b1f400a03287eb8"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94c2c13f0ee420f0cc30b983028a92616a6ab9229385d2935f40da5534beb167"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5b46efee0e9361d4b08a381cf2ccf8b783942b92fdbd7d88ed08fbf5f593038"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd8a1d51c3878cdb8c2ce1ec59df9a2acae9aff4e59549160a8f2d89a1b59b70"
    sha256 cellar: :any_skip_relocation, sonoma:        "d75f23e6ae734e9ec1f1d75627fc10136667b897ac52cf6ef93ad8ebc320b454"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5158311f5082f0ce0107b3b2037946b50169c7fd7bd73e8edb220206980a9150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1335e7ab736528573b1e53299be81fbfda683fd9daa985de2181d1ff70304407"
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
