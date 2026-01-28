class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "237c23f2eb81c56748be8f4f0da74fc8773ab2c3d0db86d098ea33d242a8e7b9"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c40460782f17396a8a9b7600b6cd7b46418200b9497fbe69cfd77a693438bcb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f94f2632b13030e1c67c3f0a1988f7de45a869ffd7791004801000fcfbaa77d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c58d4b0899589251589879a86a98a9444d0d92b845531be23420327018bbe6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a4c451ecaa6195cd56e5e8df82527ae01c9663d27c9cf6254b2a1db41655cd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07cc6f67365cf4f92c52c613ba1a44429c4003c441fdcb4ea8eda020a6f8b80b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc86d7aa7aa980a834220e53eb50c93de809426fb1e309c4b704b5eb55db1b4f"
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
