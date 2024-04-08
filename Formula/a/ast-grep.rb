class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.20.4.tar.gz"
  sha256 "4440efad1c4bc5eb7f6532e06f373f84a8c6a727babce10e97e889a9872460bc"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc3973b21fbf46ad7cea8d9eb3a5e139220dbf8c2eba9988fcbb2dc5faee66d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d8fc5952043312e3e10423ab55ad94b0d8213aa3b34ddef14d727ad8300c0b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4e3f52fdf5caf7613f0adc08c602e544202627bf128aa61bcc9c955fb043171"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4e9126ed4482e7d2afc71e336d88b8ad1ea0e156807aac2bb13a0cf95b907b1"
    sha256 cellar: :any_skip_relocation, ventura:        "a49360ad1fd0b0334a789918c2f6e3edc60ecd89f7393406513f0d65c9af09c1"
    sha256 cellar: :any_skip_relocation, monterey:       "510d0b198c40a88a3d1be159c454ab256869a9a700ee672fe4ff2ced53bc6726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ac12b54fd606f9b61ba19838e7dccf1159b127fd527db130326706e380b9065"
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
