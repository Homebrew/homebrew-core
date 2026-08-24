class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.29.1.tar.gz"
  sha256 "4447279e45a46635ea628fa9097f24561db61a0a35a30c8a21fbfc7787fe35a9"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f90eb9ae17f088a09097d7623f32389a8665a0df8787258966cee8ccc655e17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f994c74a55acfc42d8f31f83fa99dcc3273b8f0fb879f737294f36bcd6a7b4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a688463eaa360bd448213c0d63c10be0ef70f2f778191bed34c9d556db64ba65"
    sha256 cellar: :any_skip_relocation, sonoma:        "1eda84ee5dc7403a1802ae5cb35c56d61d8c2f351fdb2ebbb36201dcf38b73aa"
    sha256 cellar: :any,                 arm64_linux:   "f75dd3cdda188128dfc27e8c0104fb18751a24745bfdd03420b597facd58815a"
    sha256 cellar: :any,                 x86_64_linux:  "a779b80d3422011e2e8bf2e79cc928a589bc9c1e27ad813c2380f0d71dbfd137"
  end

  depends_on "go" => :build

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
