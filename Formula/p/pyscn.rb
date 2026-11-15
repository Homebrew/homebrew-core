class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.33.2.tar.gz"
  sha256 "8d30b2d41e0f7506a0758cc688b6f92bbe0bd01fb854edba8ff73459184aee5c"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d4a7ded6a924da4a3dc92dc84983b591890b0f0a0b5c2479c91a398d2a4195fd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aad1b4ab2ab5c38fc8bc02f915aa1123a1a556562436d49bf83dc1290ec78b6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fcec953ef124eee1a6f08a5e78395b5dbd6713d3073bc629f911182146b777bc"
    sha256 cellar: :any,                 arm64_linux:       "dddfdf1e90819edf90cbd4253863b25988dd1c4eadc17f5d04e702a4f9879f11"
    sha256 cellar: :any,                 x86_64_linux:      "0d7455d2a2c00756d895f9344e74f0519980af1cfab50659bc584672b40f5492"
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
