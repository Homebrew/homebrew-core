require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.34.0.tgz"
  sha256 "a3fe88c6457007078a73b2677cc882bba87f2e84642fcaeed51719585e122f28"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21fbe42689cddbe8ef241d408ff9a6eb7d6442573e3c6f8609945fa5ee7dc891"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21fbe42689cddbe8ef241d408ff9a6eb7d6442573e3c6f8609945fa5ee7dc891"
    sha256 cellar: :any_skip_relocation, monterey:       "71b1b1e4bb1cf09a7ef910d0cadaec32303a66dff35b35a70acb8964ffc36111"
    sha256 cellar: :any_skip_relocation, big_sur:        "71b1b1e4bb1cf09a7ef910d0cadaec32303a66dff35b35a70acb8964ffc36111"
    sha256 cellar: :any_skip_relocation, catalina:       "71b1b1e4bb1cf09a7ef910d0cadaec32303a66dff35b35a70acb8964ffc36111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21fbe42689cddbe8ef241d408ff9a6eb7d6442573e3c6f8609945fa5ee7dc891"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".gitlab-ci.yml").write <<~YML
      ---
      stages:
        - build
        - tag
      variables:
        HELLO: world
      build:
        stage: build
        needs: []
        tags:
          - shared-docker
        script:
          - echo "HELLO"
      tag-docker-image:
        stage: tag
        needs: [ build ]
        tags:
          - shared-docker
        script:
          - echo $HELLO
    YML

    system "git", "init"
    system "git", "add", ".gitlab-ci.yml"
    system "git", "commit", "-m", "'some message'"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    rm ".git/config"

    (testpath/".git/config").write <<~EOS
      [core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
        ignorecase = true
        precomposeunicode = true
      [remote "origin"]
        url = git@github.com:firecow/gitlab-ci-local.git
        fetch = +refs/heads/*:refs/remotes/origin/*
      [branch "master"]
        remote = origin
        merge = refs/heads/master
    EOS

    assert_match(/name\s*?description\s*?stage\s*?when\s*?allow_failure\s*?needs\n/,
        shell_output("#{bin}/gitlab-ci-local --list"))
  end
end
