class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.61.0.tgz"
  sha256 "66367d6e77c88a538d78c7cf862bd3099c9da85e0255f7eb5a30bc69dc8a58a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53b37483422b9cf1a5cc5280f40951d1198949d5fa3e7cd724e3999fba80b558"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53b37483422b9cf1a5cc5280f40951d1198949d5fa3e7cd724e3999fba80b558"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53b37483422b9cf1a5cc5280f40951d1198949d5fa3e7cd724e3999fba80b558"
    sha256 cellar: :any_skip_relocation, sonoma:        "d212d1ac069309d7312d914cbb9ad136f915e314ef8c6802ccdfa655dd14f35d"
    sha256 cellar: :any_skip_relocation, ventura:       "d212d1ac069309d7312d914cbb9ad136f915e314ef8c6802ccdfa655dd14f35d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53b37483422b9cf1a5cc5280f40951d1198949d5fa3e7cd724e3999fba80b558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53b37483422b9cf1a5cc5280f40951d1198949d5fa3e7cd724e3999fba80b558"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/".gitlab-ci.yml").write <<~YAML
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
    YAML

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
