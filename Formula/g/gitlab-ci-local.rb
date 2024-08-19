class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.52.2.tgz"
  sha256 "c604bd7659ebffe8f5fd6ae90545f882b93bc6cededeb102167fbe72fe7d0950"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "251e46c484c28faa95aa8cec426e066e013e647c79523955d252a51d5ab1c984"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "251e46c484c28faa95aa8cec426e066e013e647c79523955d252a51d5ab1c984"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "251e46c484c28faa95aa8cec426e066e013e647c79523955d252a51d5ab1c984"
    sha256 cellar: :any_skip_relocation, sonoma:         "90004d99bbd489474b740c9d6a52f40064cd76bcc58fd3d1faa894a9b67cd277"
    sha256 cellar: :any_skip_relocation, ventura:        "90004d99bbd489474b740c9d6a52f40064cd76bcc58fd3d1faa894a9b67cd277"
    sha256 cellar: :any_skip_relocation, monterey:       "90004d99bbd489474b740c9d6a52f40064cd76bcc58fd3d1faa894a9b67cd277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d99bc0193be79d676a0dbf430a91213717bb20ee15db5ef8d0b420c8c0f298aa"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
