class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.40.0.tar.gz"
  sha256 "575d9c71ade98d6fb883a444a8b490ea7d0faca5bd09228c9cb2250e7276fbb6"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9057203ad4d72c7676a20d14ad1e4e9a44f040f34c41357da8b2049f2a0dd15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8de64c42257dfdaaa67206d6ccefce6180bcd2d5aef33b9de153360c111d765a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcdd07af963039f877b1303a89ccd751c481b0f3bd55290bcc00540e9a677cc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "965facaa38fa294f22b7034b6147fbe59ab6aae36f5039f98d054836d86dcf41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fecd2f345cbf935c48039dcc8c083e90182e0241a07477aece6149ffd49d05d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68f853a02bb07956736d0ad7d4628603c10e64c2f1d816bbf0fceda34311c14b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"ast-grep", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
