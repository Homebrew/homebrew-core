class GitAutocommitCli < Formula
  desc "AutoCommit is a powerful CLI tool that leverages AI to generate meaningful commit and PR messages"
  homepage "https://github.com/Ibrahim-Haroon/git-autocommit-cli"
  url "https://github.com/Ibrahim-Haroon/git-autocommit-cli/releases/download/v1.0.6/git-auto-commit-cli-1.0.6-all.jar"
  sha256 "26e66c6fbdcb048026b249c20b890e6a81b4426bc1d784568d9c5d8daadfda8d"
  license "MIT"

  depends_on "openjdk"

  def install
    libexec.install "git-auto-commit-cli-1.0.6-all.jar"
    (bin/"autocommit").write <<~EOS
      #!/bin/bash
      exec java -jar "#{libexec}/git-auto-commit-cli-1.0.6-all.jar" "$@"
    EOS
  end

  test do
    assert_match "CLI tool installed correctly", shell_output("#{bin}/autocommit --test")
  end
end