class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.32.5.tar.gz"
  sha256 "608447b4ec5dfe1f35b5689abffd8ce6d9d558d0c48b98ef341a4fd9a92210ce"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7a37035de372e1b1dbc21e4c83e0c56e02dbcfae4b8f22340a637c572a0083bd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd185c29c09b2fe47bf3c82107ec3e85e0b9ac8d17cc6e74371f198936080a51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d91649c5071b56ff539a879c3da6c15f2aefbbbac85a95dd6f9a44ca92296cfe"
    sha256 cellar: :any,                 arm64_linux:       "ca852a4e505503e4c70952d7508c9e9bd187169d394ec0aabfdd93d4b7c1e958"
    sha256 cellar: :any,                 x86_64_linux:      "2f4310cd6b3681570347161e1785a0ec065730583887dda02792ea38e771587c"
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
