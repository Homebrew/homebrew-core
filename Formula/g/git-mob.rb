class GitMob < Formula
  desc "CLI tool for including co-authors in commits"
  homepage "https://github.com/rkotze/git-mob/blob/master/packages/git-mob"
  url "https://registry.npmjs.org/git-mob/-/git-mob-4.0.1.tgz"
  sha256 "b2f2c558aa7674b1275bb4f92cd6b967c90a6ee8a8db7d3a567524bf33d78242"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d4df77faaec483ecc9ad676aee4b794f318a0a511495aaa22886a3c0f54d74a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d4df77faaec483ecc9ad676aee4b794f318a0a511495aaa22886a3c0f54d74a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d4df77faaec483ecc9ad676aee4b794f318a0a511495aaa22886a3c0f54d74a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b53efab454df496e789a6daa64025ca50c6e81168123f600d7a1e57ad00b005"
    sha256 cellar: :any_skip_relocation, ventura:       "3b53efab454df496e789a6daa64025ca50c6e81168123f600d7a1e57ad00b005"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d4df77faaec483ecc9ad676aee4b794f318a0a511495aaa22886a3c0f54d74a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d4df77faaec483ecc9ad676aee4b794f318a0a511495aaa22886a3c0f54d74a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "config", "--global", "user.name", "Jane Doe"
    system "git", "config", "--global", "user.email", "jane@example.com"

    coauthors_init = {
      "coauthors" => {
        "ad" => { "name" => "Amy Doe", "email" => "amy@findmypast.com" },
        "bd" => { "name" => "Bob Doe", "email" => "bob@findmypast.com" },
      },
    }
    (testpath/".git-coauthors").write JSON.pretty_generate(coauthors_init)

    system bin/"git-add-coauthor", "bb", "Barry Butterworth", "barry@butterworth.org"
    assert_equal 3, JSON.parse((testpath/".git-coauthors").read)["coauthors"].size

    system "git", "config", "--global", "git-mob-config.github-fetch", "true"
    system bin/"git-mob", "BrewTestBot"
    assert_equal 4, JSON.parse((testpath/".git-coauthors").read)["coauthors"].size

    system bin/"git-mob", "bb"

    script = testpath/".git/hooks/prepare-commit-msg"
    script.write <<~NODEJS
      #!/usr/bin/env node
      import { exec } from 'node:child_process';
      import { readFileSync, writeFileSync } from 'node:fs';

      const commitMessage = process.argv[2];
      if (/COMMIT_EDITMSG/g.test(commitMessage)) {
        exec('git mob-print', function (err, stdout) {
          if (err || !stdout.trim().length) process.exit(0);
          const contents = readFileSync(commitMessage);
          const commentPos = contents.indexOf('# ');
          writeFileSync(commitMessage, contents.slice(0, commentPos) + stdout + contents.slice(commentPos));
        });
      }
    NODEJS
    chmod "+x", script

    system "git", "commit", "--allow-empty", '--message="initial commit"', "--quiet"
    assert_match "Co-authored-by: Barry Butterworth <barry@butterworth.org>",
                 shell_output('git log -1 --pretty=format:"%b"').strip
  end
end
