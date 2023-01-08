require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.37.0.tgz"
  sha256 "5d1fea50de3cf79784d3a344d0c4afb791bfab1dff810080fc7749a9fee8c0ba"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c692bf6b8c617f277342d64d96d8f13351273ed200f202df5c5cb65221d577f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c692bf6b8c617f277342d64d96d8f13351273ed200f202df5c5cb65221d577f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c692bf6b8c617f277342d64d96d8f13351273ed200f202df5c5cb65221d577f"
    sha256 cellar: :any_skip_relocation, ventura:        "a429b3cddb67704f58cdb0ab46da1e543b69558112e6c1555fe8f8c01bb1f7bc"
    sha256 cellar: :any_skip_relocation, monterey:       "a429b3cddb67704f58cdb0ab46da1e543b69558112e6c1555fe8f8c01bb1f7bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "a429b3cddb67704f58cdb0ab46da1e543b69558112e6c1555fe8f8c01bb1f7bc"
    sha256 cellar: :any_skip_relocation, catalina:       "a429b3cddb67704f58cdb0ab46da1e543b69558112e6c1555fe8f8c01bb1f7bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c692bf6b8c617f277342d64d96d8f13351273ed200f202df5c5cb65221d577f"
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
