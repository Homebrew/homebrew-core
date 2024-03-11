class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://github.com/atuinsh/atuin"
  url "https://github.com/atuinsh/atuin/archive/refs/tags/v18.1.0.tar.gz"
  sha256 "17712bed6528a7f82cc1dffd56b7effe28270ee2f99247908d7a6adff9474338"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c098606c38a475a8409c728b4ab32e14a500b9051ba1d2cfcaf2e86cb509a288"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3f44d38e5b7d85cb18a1aee12fad0c60174cd0f0363497d42ec7e7e7d15a21c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08be5279725d01d1214dc0813482f42498d7d95a8583776633f28435f4a44aa2"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8fd1309d6fc6448f8aa2d02f72bc749d59a5b51c983ef9b459b9623dc8d33e7"
    sha256 cellar: :any_skip_relocation, ventura:        "05f05d6da4cd4779ee4054440565a42cc0d4c8caa0132a7ae2dd06f467dbc693"
    sha256 cellar: :any_skip_relocation, monterey:       "40c08058db6179dfa69459b66b536b499edcc9d8c3cb5e809b57779d207e856f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0455254129c7aa00511400d714cd480f6b067207f6d8994980efe45a6fa1b234"
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
