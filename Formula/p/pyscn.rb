class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "641bc15c116622dbc02ec035b4872b825e7bf8171ed9967162c8f5c9d6a290c6"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73b0ded22ecee1d72a82adccc033cc29410f51cbd2bfa2fd7e33a26bb2c34b6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bc3da127823e040e36ab81ca637fb11f859b1b770869d9da897a3c72a9b63be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d891ef8988755abc280d29b1bc98cd24e4e100d67fdd4cdeb7b1e1c911ec06f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "19e6531664b530013b9173366581ebf4d5863ac77d11c4806da6361238847ffd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be0581be7037b7a9001aeb493b29ef87b55de2889ee026891728529bcec31a95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96b1014fc4abe08bf4f9f552f3a9dcbf666edea2bde5586059d1cb63730d462f"
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
