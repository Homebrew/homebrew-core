class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.59.0.tgz"
  sha256 "fe09e66948460775bed2e80bab3b164a936f82d2e04b3b6c9515160994bab9cc"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "41ce596f09e7548fee915cc867bf036d51a20d7f2c173d3e429f55f58e2c6ab2"
    sha256                               arm64_sonoma:  "07d239e1b29a6ab0d954237efc29ab77864d49b0d277f98ef735108c5d2c700a"
    sha256                               arm64_ventura: "abad47305385b56761db451df16c1bf4d3025387ee59bb032e6459fd27a8806f"
    sha256                               sonoma:        "884d73ebe095680ac70c9f97179c25ed072ef377308a2ffc53a27c883dc8465f"
    sha256                               ventura:       "604acceeebeda180cf18697bc05e38d75ce89308e837ae7ffa421b03824d81b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c7c400e45d6452c27cb9a77058915bacc3b7e9d835428074e5d0cadc17f21c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f015ce0d597c1dd770e292a177860bf5c1b6b54539b6374be8daaf3aa5bb2528"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
