require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.40.0.tgz"
  sha256 "97b60effa14ecfcad6ff3f869f008b8ab7e4cee986c2e41dad7f7df8fb2d3703"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5da05ee0333707c4407ef630cb0580884d2bc56f05e960d9a5272e70182a267d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5da05ee0333707c4407ef630cb0580884d2bc56f05e960d9a5272e70182a267d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5da05ee0333707c4407ef630cb0580884d2bc56f05e960d9a5272e70182a267d"
    sha256 cellar: :any_skip_relocation, ventura:        "658a6793d7839ab35eabe4cc56b9dcd411e6d67c92956d93cc5abbcb6e1b1ffc"
    sha256 cellar: :any_skip_relocation, monterey:       "658a6793d7839ab35eabe4cc56b9dcd411e6d67c92956d93cc5abbcb6e1b1ffc"
    sha256 cellar: :any_skip_relocation, big_sur:        "658a6793d7839ab35eabe4cc56b9dcd411e6d67c92956d93cc5abbcb6e1b1ffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5da05ee0333707c4407ef630cb0580884d2bc56f05e960d9a5272e70182a267d"
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
