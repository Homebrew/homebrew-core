class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "87592d811e86f19f200ed2ba806b6521512947f58b4547d1eadae1e5fa97615e"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9feef71a2e05ff735d0ba7d2713ae1760dedb8637328fe4cf189784a5dd5d300"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fcee553cdc34b0ca0fbec8da36ec48a37b303e95d2752c865c4c5bf6e4ecbb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83cebc064e1f94913dc385d6bdd846147ac846551417ac95b95c7db38982b8bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbbaae35f264915ba94b7334e1e5636d295ea78544006c8d97e539412a2cc3f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e0c198cd1a84e16a4a543dde6430827f76a9f547677a7345ee8c8ad7b819f6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "832660d34901d368daee21951dd6309242bec596183e16fc23d727c814107298"
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
