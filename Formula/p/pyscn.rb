class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "13f9c07eb1718f677a705466b1c64e131e3543e4f3c2b8a363b6c1c054fdab17"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47808b1c063eb9bf5a97b7b19d91ee1038c0f5efca12586f7d367a5271712553"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9137d8e1a971fb659b16e04785f30c91ff664c142ddb268f8fc915615568f3f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bc33674cd759d12da6ed0976f777df6efaf336f554c4ff7877befe02ab0cfc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e14e500a3a1e10b44985bca6942199a057d0831d18715fbbe415096dd2f7b989"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d157e478469273bbfe9303585e536b129bb30b32be4fc702f114826597784860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5648d1cd4e97917df4a0bf427cf0a91924669849bce589291441f8da94317b4f"
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
