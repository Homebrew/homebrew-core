require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.27.0.tgz"
  sha256 "6575b5552e3076ed911b40b2c8ac06e04e82dcb46ad481f72c30e85ec1377854"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1165663956d0015dc2e6558ff14d04bda0b54a55bebc030743af471f5610e5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1165663956d0015dc2e6558ff14d04bda0b54a55bebc030743af471f5610e5c"
    sha256 cellar: :any_skip_relocation, monterey:       "3208eeca91d6338caff53f878e87d1d4956d4172649daef647b5ae944a45cce1"
    sha256 cellar: :any_skip_relocation, big_sur:        "3208eeca91d6338caff53f878e87d1d4956d4172649daef647b5ae944a45cce1"
    sha256 cellar: :any_skip_relocation, catalina:       "3208eeca91d6338caff53f878e87d1d4956d4172649daef647b5ae944a45cce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1165663956d0015dc2e6558ff14d04bda0b54a55bebc030743af471f5610e5c"
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

    assert_equal shell_output("#{bin}/gitlab-ci-local --list"), <<~OUTPUT
      name              description  stage  when        allow_failure  needs
      build                          build  on_success  false          []
      tag-docker-image               tag    on_success  false          [build]
    OUTPUT
  end
end
