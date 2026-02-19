class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.34.3.tar.gz"
  sha256 "5f3bd74c54e98f43da6e93298b645593ea6c11a9581b89237d693d9238b98ecb"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c17c33425a5eff6327205e82feea282a73b596e2f785b265b7da396aac1434b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec4bacb245eed93622a44b3e91004118f0f22f74fa2f96d3de5791dff0858cd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a22481e8671c796c9fed459370206bf4ad3d684d4568411d35480a0578fdfee"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcea3c19d85ff8d64ef8d0790ca7d51ec3ba03f8bdd8f2bd471c7032e0553880"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b1db287d1fb9277ee8cc8a44f6e1c7329a845fb062fc0348911618cba9c1cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d10320f79eda47dbe8cd3b77aeea31946675dff3329fe16710e105568b665e15"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
