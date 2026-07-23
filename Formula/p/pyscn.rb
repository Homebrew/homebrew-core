class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.26.4.tar.gz"
  sha256 "025c01096d2578cf208fb01a7648205300429834c40fed65e38cc0f016adb202"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8ca7f4548411e384a7e8a78fa14bce225664a2914adf942d01ff8a7d7dae91b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22396f5216ef21ab8098b540777f00c0237639dc10f13968c8d5d56907f52b64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6b78ec68097aa3128c5a32adeca0b20efb548be21d7398398ea0dd73bf18789"
    sha256 cellar: :any_skip_relocation, sonoma:        "19ff07e6aaf070cfc75772cae67c5e0e283121c78e762601b68c6132bacba649"
    sha256 cellar: :any,                 arm64_linux:   "299460d358f42bb39174056c10a6145efc5457c25add0098cf1f24082cc4b01d"
    sha256 cellar: :any,                 x86_64_linux:  "ba50d1f9bd72bbdba79e7b7d04be601b847b21f9afc8a557bd88ebe79850cadc"
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
