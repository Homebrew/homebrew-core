require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.31.0.tgz"
  sha256 "2444a3123b32e4ae0b81076008e12f2e182c0afe117823fe83e4a43cb77dca67"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0224c942134ee83d1aa47e861e035f34942093d7bc0607270b8e6c9807c96748"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0224c942134ee83d1aa47e861e035f34942093d7bc0607270b8e6c9807c96748"
    sha256 cellar: :any_skip_relocation, monterey:       "779e48b1888af7fc9883c972e0ca3e09305f5e22bce24cca940a287c4a1aa4aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "779e48b1888af7fc9883c972e0ca3e09305f5e22bce24cca940a287c4a1aa4aa"
    sha256 cellar: :any_skip_relocation, catalina:       "779e48b1888af7fc9883c972e0ca3e09305f5e22bce24cca940a287c4a1aa4aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0224c942134ee83d1aa47e861e035f34942093d7bc0607270b8e6c9807c96748"
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
