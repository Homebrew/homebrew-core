class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.23.0.tar.gz"
  sha256 "d02fad339db453950ffdf90e63b3af4d91ae2b63d6cdb2c0103c9d328923938a"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea6d5e420d3db462c0eda15f3022f1a474e89c41e4229ae6bc87e190f642361d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adfd9f265f38b06732383565ccdbd4ee573f6e3e5ec2b0f8ce88bb185799e624"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc7d9915167565fe355e7c68df1f2a4043aec22f545b44a04d46cfab8c625a19"
    sha256 cellar: :any_skip_relocation, sonoma:         "bff5b99e00da5a2e85f71d8b9d798d687ad09194f1675623d6b992da397c7111"
    sha256 cellar: :any_skip_relocation, ventura:        "218e35853f91f0e895231466443df6bfe3945c89513539fd5af1c7f9edd57d69"
    sha256 cellar: :any_skip_relocation, monterey:       "157cd838b63889a6dbcba131614e247ed2f62456b182ef02e98f10981a904f6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9f68518ac66912e0172b9f313378191e4d2f3766fc56a29bddc2f1c933d32b4"
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
