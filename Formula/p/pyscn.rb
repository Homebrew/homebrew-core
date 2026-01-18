class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "150370f1707d67b11cebe4a6652eacef9b61b872076b59b24039e49a02246983"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6c6352c339325b232b398c7eceed7330a978be31f6440f4b981d8a5068af1ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd09beb9fc71b89aee3854d758db62906d53b186560468bd3e8a346375ed5ad7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c997e9216dccdcdbeac3adc3eaaeb0f84ad738ddc0d714e4be3f427d4377ffe"
    sha256 cellar: :any_skip_relocation, sonoma:        "ade13e6df90eaef572be9fbd9f343e3c0b1013618933abe48814dccf3c4f89b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7f2450699412347dca17778986d7f5577e3b97d6b1d58eb8af0e474edf1bd14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "815a48c055c7369f11d6348160ecd64f6f6886e4c2958a6dc33414695c071e7f"
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
