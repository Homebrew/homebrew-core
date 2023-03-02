require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.39.0.tgz"
  sha256 "83ebc56e3c39a6d11f7ad3ef77ca0ebfbbea18443ad759de6eb43b2479c0a912"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "143bc9e10cd9f7419a60676ac95173acfaa954bd8cd2c050cd06156eb350834e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25460f50a2d9009db3b7317fc2642bd09bf2ae9d4ade0bf958c39e6da9515f01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "399c8a0e15bf65fd5f3891c5ab9e487da4313a366cceaa2d8ca3f2c3215dd912"
    sha256 cellar: :any_skip_relocation, ventura:        "6cdc076fb19c4e3f36fab95885eca93a328b3a19261a2885328ad8abf8ec8784"
    sha256 cellar: :any_skip_relocation, monterey:       "cd67e61e8fd84e5b20cb5f29e77861fd43cc56f2b0dfbba11bf72ad0f786f7d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ab849346e36516bb46015aa974b5920903642ce19e563ea7a5bc2ce1a672735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d26ef15ac46459a1c70d2af31c905f5c1b27beff4acb68fea1b9f1e93b029c6f"
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
