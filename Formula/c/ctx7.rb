class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.3.6.tgz"
  sha256 "4924060b36d38259182f980d6cd752c0e99f529f2117d0b584dbcbb4b6552cf4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2076f22f4a9de8245ef030241a7882786fb087ffe32ba870f8a7b6e0b8b4f391"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"ctx7", "setup", "--cli", "--claude", "--yes", "--api-key", "ctx7sk_test_key"

    credentials = JSON.parse((testpath/".context7/credentials.json").read)
    assert_equal "ctx7sk_test_key", credentials["access_token"]
    assert_path_exists testpath/".claude/skills/find-docs/SKILL.md"

    assert_match "find-docs", shell_output("#{bin}/ctx7 skills list")

    assert_match "Invalid API key",
      shell_output("#{bin}/ctx7 library react hooks 2>&1", 1)
  end
end
