class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://github.com/atuinsh/atuin"
  url "https://github.com/atuinsh/atuin/archive/refs/tags/v18.1.0.tar.gz"
  sha256 "17712bed6528a7f82cc1dffd56b7effe28270ee2f99247908d7a6adff9474338"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61780b02d585f55a59ea85b75c2e7790ff2a82f0ff37d85a597e0fce2fbf50b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32bea2303660f831f30546e78bf11e861eaa60f3fa0b4ff7de07e6c34635f732"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98f9d67a925c0483d4a73f245d4520dacfa73ef4aa3739c2ef7484159e5452b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec6259ad6ae5f85c7c578d64da8360ace6b0b103b9e00dc9e34ef4d9ab58a5b7"
    sha256 cellar: :any_skip_relocation, ventura:        "5d2ca1713f5eb58cad25bab2610453fa351adbceb8b1179cfc3c7ef3a5d4b5df"
    sha256 cellar: :any_skip_relocation, monterey:       "2d56bdc1c0b80c7a198f072253144b967b4104e132d457440738e9ae9d80141b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0da4cc8bc00cd2c0abcf71354e4e95af022b078b41592312855f6268c3dab49"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell")
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}/atuin init zsh")
    assert shell_output("#{bin}/atuin history list").blank?
  end
end
