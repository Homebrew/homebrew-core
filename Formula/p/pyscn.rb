class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "237c23f2eb81c56748be8f4f0da74fc8773ab2c3d0db86d098ea33d242a8e7b9"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76758f7b17bb38d6f1d815e434df9b73ac728c098695075e4c39c20f9752643c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6db0bd1831bfb784e7035839cff58b07c92e013132767cf8a8c34600f0bf3ce7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2136afe24e42eeaabeb1ce22a043e27dd9506a5289b9935a435d2d25e0596f98"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dec8efe422ed74fff5517058331a8009a03118a0757d953d8f3ae21fafb52cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dcb1d383ebe25df3cd04aff454443d38522b99fdbf24625d4b055bcf2e8013a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21a2813bae2b4f0ea4317baa7e294817b406fa356999db6025c4a2361b6fa33a"
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
