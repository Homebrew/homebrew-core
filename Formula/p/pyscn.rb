class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "0f52464e0ae6d3d18016e264d59b0f7a8bd412f66e74c5658017c98de1da81ef"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d12124cf308e06ad73003620178c75fbc635017132d33687bfd360231605ec9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4df4564a84829e519550ae30a5f7dfdcf95d4cd2c46ca59ec0fd1b2fa078c6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "926768903e689ae3fa9de4cf64b2265f6a5b2420db116d166f643675d464d844"
    sha256 cellar: :any_skip_relocation, sonoma:        "b392cf754148343cab17adb1d5414e979163cfcdcf92545a78678fb4d89740dd"
    sha256 cellar: :any,                 arm64_linux:   "32aaa857b44ffc9cfc7c5eba0e0bdba12f45a5264c4fe2239efd20fc92043e36"
    sha256 cellar: :any,                 x86_64_linux:  "3e66f41d3f422d7084b17dbfd1629507e3403c798ed65687eee13e16db189190"
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
