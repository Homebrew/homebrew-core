class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.28.0.tar.gz"
  sha256 "697adc13c11952529e8b6592b84b2cd3e08a57a13ebafe48ff0ef470e1ccfe1b"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e695195dd021184b1be6b43e95b11b581fc23ddf675c372927034359b649a4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05754215b9e124f960181201775ed1ffde2a2eccfd572e1862892e0e756f1f40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a56d7884dba68b2078d67b3691590a3082c67f97c0051b3a801dadf656ce42c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8667ca673abaac35ee307c18d737de91ee0e5d8548c9e2fb6194441593145d40"
    sha256 cellar: :any_skip_relocation, ventura:       "cd3b90ba7b6d8126806697141d73431593d9a380a166e626883c0d035cb3c88c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "252406f2bd1c937b3af980dc8f132ca05866e376b4f2320bb55859ddd01c5e7e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
    generate_completions_from_executable(bin/"sg", "completions", base_name: "sg")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
