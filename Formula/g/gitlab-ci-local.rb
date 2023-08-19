require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.42.0.tgz"
  sha256 "b278af22b6423f88cdfb4ff771ef6fb40e864585ed2ee4ccfa6a9334b4732619"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18b976aea6d141e85d09fa2e387f318d51b02137c488c35b2b4aef2b3d344f34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18b976aea6d141e85d09fa2e387f318d51b02137c488c35b2b4aef2b3d344f34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18b976aea6d141e85d09fa2e387f318d51b02137c488c35b2b4aef2b3d344f34"
    sha256 cellar: :any_skip_relocation, ventura:        "cc3ea34ee93bda6cbeb81e05fdbfe99e8c58d54a542b2d08334d8dddcb37497d"
    sha256 cellar: :any_skip_relocation, monterey:       "cc3ea34ee93bda6cbeb81e05fdbfe99e8c58d54a542b2d08334d8dddcb37497d"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc3ea34ee93bda6cbeb81e05fdbfe99e8c58d54a542b2d08334d8dddcb37497d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c942d1207f92f5c7fed131b56eeb1e9e4a2ce15014358b5072e8421f949c8b4"
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
