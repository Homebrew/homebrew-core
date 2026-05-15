class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.19.3.tar.gz"
  sha256 "0b4a64436e2ac88afbb0a2a472fcfbd30a2e62e6ad3edcda1d2be1fbdda00d8e"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf17b4d552c2f7d50575a45356c04c7943d5cb07a89a9dfe817d3ab67ec41a61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a94a00c067a4181f846d0962e270da44ee034a0f40a4d89c5a143a7613e05e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecf2c99ca5811f92a74a28e90c1c57765215872279e81aa6b2980c82b3a28c1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "76acb3dfc96815a68770d4dfa77fd35a8bac8796322ae13abaa4358241807276"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8dc52128e761bf10bcfa83bcce359cf91ec1277e4f3a556c34e99c57876ada5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46f2b1ae42b6c4336bdb045670996459012fad9167661b28987cab652f1b5a4f"
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
