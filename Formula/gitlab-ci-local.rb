require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.26.0.tgz"
  sha256 "3fc21fb40367f267e50cb3172be34ac15140f589492e5d0c196797e941acb468"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ed3c05e0d495cb844148f2b20bc8c813ff5debc4126ce32e6bd18cca8e32232f"
    sha256 cellar: :any_skip_relocation, big_sur:       "f9baf713fd0af0e88a1faec18b5d49dffd2674e6f4f2a1268b6675494bc0e6db"
    sha256 cellar: :any_skip_relocation, catalina:      "f9baf713fd0af0e88a1faec18b5d49dffd2674e6f4f2a1268b6675494bc0e6db"
    sha256 cellar: :any_skip_relocation, mojave:        "f9baf713fd0af0e88a1faec18b5d49dffd2674e6f4f2a1268b6675494bc0e6db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed3c05e0d495cb844148f2b20bc8c813ff5debc4126ce32e6bd18cca8e32232f"
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
