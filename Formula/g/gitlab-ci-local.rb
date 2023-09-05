require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.43.0.tgz"
  sha256 "ccb2f2bed0ef73bf8287f769770b692aa65f47cd37c024eb2331f9b7afc256b3"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a3715b632d061230aa8bbbffc5915c5d3a4d939481c34a5ea70d32906a4b65a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a3715b632d061230aa8bbbffc5915c5d3a4d939481c34a5ea70d32906a4b65a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a3715b632d061230aa8bbbffc5915c5d3a4d939481c34a5ea70d32906a4b65a"
    sha256 cellar: :any_skip_relocation, ventura:        "18cecf9e17d5404ef3539f74f433db107fe48e50065ccc3160832c26bab9eca2"
    sha256 cellar: :any_skip_relocation, monterey:       "18cecf9e17d5404ef3539f74f433db107fe48e50065ccc3160832c26bab9eca2"
    sha256 cellar: :any_skip_relocation, big_sur:        "18cecf9e17d5404ef3539f74f433db107fe48e50065ccc3160832c26bab9eca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a3715b632d061230aa8bbbffc5915c5d3a4d939481c34a5ea70d32906a4b65a"
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
