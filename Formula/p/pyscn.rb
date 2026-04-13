class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "feffd33e088fae9dbcd2aeeb8f89d03496f22a57ebf9d6d6a8f4dd26ddc53615"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9552cf9f44f33639b7f67bcbe6827ed87150ea4e573d2ae2fd47dccab6fa7801"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "329b42917554a0a9ff99531b4bc957a079a4229697d00d9d4c8eab0bb9c6d033"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "335924f3823515c66a182fa4bd8bfec538fd33f0e41ecc17e681f8e7436a06db"
    sha256 cellar: :any_skip_relocation, sonoma:        "afcfea858ac7e3d96d71cd717fc2bdea81b1d315818e24a7ae9e1a5bb32750ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33e98dbc6f4f5b1095979e99311e3af44b422dbe0412f662855e214715805be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5aa847ebc50ff6f4f288d5c739f883042a71a053cad420a800cd83c717d31f60"
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
