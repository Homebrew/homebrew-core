require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.39.0.tgz"
  sha256 "83ebc56e3c39a6d11f7ad3ef77ca0ebfbbea18443ad759de6eb43b2479c0a912"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4757d09fdd5bca9fd10c8db419116729ad0472ed37952181d1b9022d59eb8d06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4757d09fdd5bca9fd10c8db419116729ad0472ed37952181d1b9022d59eb8d06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4757d09fdd5bca9fd10c8db419116729ad0472ed37952181d1b9022d59eb8d06"
    sha256 cellar: :any_skip_relocation, ventura:        "fcafa73026725b325670a0b05fc88375d3c9c47722b89dea5948290efcc44929"
    sha256 cellar: :any_skip_relocation, monterey:       "fcafa73026725b325670a0b05fc88375d3c9c47722b89dea5948290efcc44929"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcafa73026725b325670a0b05fc88375d3c9c47722b89dea5948290efcc44929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4757d09fdd5bca9fd10c8db419116729ad0472ed37952181d1b9022d59eb8d06"
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
