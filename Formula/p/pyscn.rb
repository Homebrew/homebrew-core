class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "37017bf85bc86919efdaf3bc2b8c60cdba263dc389a41f48f95ab3403a31b4cb"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c8b4a0203190a4cec93fec18f731fb7cbfdc2607a2204ea9090bee8c17facd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12127f9840f9b23dea8281e7d2508674ccdffd84e1fe7a855f52654151e141c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd84b8667f92f590d46b5b42fe29486e73c8e5635677fbca06f1cd30c40678ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c38b6a8c372ac3d190fc345ad9777981eb3fe2d98c63f57e1ca93103a3401b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7873315665245aaee0c3a9efb8da8ffea84e9697d01536105d3325a0cd690f20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8597a1ac619d39a0bd81998e7cbf24655534f44145bb7907e4e831cc682bba81"
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
