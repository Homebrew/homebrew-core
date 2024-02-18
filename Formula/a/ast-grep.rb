class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.19.0.tar.gz"
  sha256 "6d6c1c6a1b45f128c1954b5b5d98ce9c16760e2f4aae607aa1a439a04462f604"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac57db8bfb2bbf41098b8fa5d2564da81b9f11069cd01b9eed879602e6c4a0b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3851cc01f02b64f06b75f7fbf4b728bf85d3698df7c17beeaaef1334f850c92c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af6fc4dd52fc9815f7a228e0aac6f7dc7302a702b64a5dbfa6ad8d54f70dba2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1ee85454150a999475af6ee49533fddc169b2bd0467cbbf41b3b84d3a1e429a"
    sha256 cellar: :any_skip_relocation, ventura:        "4f71b6da8c9ffbffa1fd7146100c356d87f4ad9d4ea508531b8c856b670ee5fc"
    sha256 cellar: :any_skip_relocation, monterey:       "2a0bae06247381f3c85360752976a8ca140cbda38eeb982c6bd3e527b89c8f8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "137415a769330cc6e649b273bce42b0d40cb35072d233201be4330d8bcc4206b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
