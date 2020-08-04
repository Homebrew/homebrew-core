class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli.git",
    tag:      "v0.11.1",
    revision: "58bd549de5db008e9dd92cb6673b9ed85449d778"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c407d1a98c582f12b7830c854b1c29e706a4215b5d5fae94cdf85b1929a9dfe" => :catalina
    sha256 "d758ddf6c6e240b09cb2133a35b4c05cf78c722d1e54f40622485628a6d544ac" => :mojave
    sha256 "9f65a309f159a2bed8f7b4d737aa01b4b4f7037cf79f8b112db4f04ac38a3666" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "bin/gh", "manpages"
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    (bash_completion/"gh").write `#{bin}/gh completion -s bash`
    (fish_completion/"gh.fish").write `#{bin}/gh completion -s fish`
    (zsh_completion/"_gh").write `#{bin}/gh completion -s zsh`
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
