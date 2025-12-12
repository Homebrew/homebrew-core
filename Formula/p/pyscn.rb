class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "dc8d5f27da8ea1c8a2f3831ccbfc8eafa2fe96053be837bb892c6f26242d7928"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d1174a6bea25357e7332c876a7c69e4c54e0d62d2cac3e7487cbede1fc67795"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc51bdd0c11baede86044cd4a27e1c976f3aea4b512792f19f5a79d1624f2d58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fd8ff1aa70796d86019d937d7ff492ae9de2065f322ec9d58b87f67fce8b333"
    sha256 cellar: :any_skip_relocation, sonoma:        "03b3095fb6cc4f01cbc1c592b1f11117d2a502be8111faf07d2f62028d89060e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dae356ccfbcb1c3951960cf9a98b5b5f955c52ab5b633f468c4aa40156b859d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c986e17051ae77a0494be217f4985d2871268e867ecdf1398e9f1773d80c23c"
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

    generate_completions_from_executable(bin/"pyscn", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
