class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://github.com/cocogitto/cocogitto"
  url "https://github.com/cocogitto/cocogitto/archive/refs/tags/5.2.0.tar.gz"
  sha256 "99f9dee05597d7721f6d046dbfefba5cb8d1c4ae22ced415f724affb3a6bd0cc"
  license "MIT"

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", *std_cargo_args
    generate_completions_from_executable(bin/"cog", "generate-completions", base_name: "cog")
  end

  test do
    assert_match "_cog()", shell_output("#{bin}/cog generate-completions bash")
    assert_match "#compdef cog", shell_output("#{bin}/cog generate-completions zsh")
    assert_match "set edit:completion:arg-completer[cog]", shell_output("#{bin}/cog generate-completions elvish")
    assert_match "complete -c cog -n", shell_output("#{bin}/cog generate-completions fish")
  end
end
