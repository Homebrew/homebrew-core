class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "2e5309e3865e0e6b486cba4016245afbe287ed537370eb747d05042b27145761"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a33d1ff7ff2a6276fd286bc02c4e7da74c9e9723c92c1feaf7884da926becbed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e762e2c12d7d00558e30ddec4716055808ea54066848ebb0f018972bedc983c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "470d1903427ef91a8a638c4ea9254b7ed8dc9e03bbe6b0d211af9beaeeeeb7cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3de71710a75a59860e44ec516d1c354d71071faeea7d73380c1cf8cd228c9da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d39cad53a1ab976fdcb87488b6a0a43cb92222eef32f6c88a126a13ebb21da83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "beba669ae6473efbd7f2dcedd386e4ecdc97d84c1238216d54de8094242237c8"
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
