require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.50.1.tgz"
  sha256 "fb4e55cbb62c9ccde5a6c40ebbc832cc524bd7c28f86161b57f0406a218832ca"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "217b7772aa0cea839534325fc798c6a7ad82a05cf68989292eedbec933e80789"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "217b7772aa0cea839534325fc798c6a7ad82a05cf68989292eedbec933e80789"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "217b7772aa0cea839534325fc798c6a7ad82a05cf68989292eedbec933e80789"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a18522a204f8b1734c153c7c73eb41a28cee408946dcc29219c5030ae281251"
    sha256 cellar: :any_skip_relocation, ventura:        "1a18522a204f8b1734c153c7c73eb41a28cee408946dcc29219c5030ae281251"
    sha256 cellar: :any_skip_relocation, monterey:       "1a18522a204f8b1734c153c7c73eb41a28cee408946dcc29219c5030ae281251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a99cb8427e5e1e079563a07402cf93b37dd3f8668d39735103d73508364c8ce8"
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
