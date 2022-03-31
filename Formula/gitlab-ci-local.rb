require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.30.1.tgz"
  sha256 "43bbead096b80273183da39736bc5e98cf2b15ce7e5f548dd0faef7d53dcc43c"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38ad9ddf6c3686dd6b9175503ebf94e6e4e4918931d8cbd41fe85912c507ccef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38ad9ddf6c3686dd6b9175503ebf94e6e4e4918931d8cbd41fe85912c507ccef"
    sha256 cellar: :any_skip_relocation, monterey:       "a35973d863752b567f44bf89015ce23a786a14b585f21cb6e99929bf0a9a0b18"
    sha256 cellar: :any_skip_relocation, big_sur:        "a35973d863752b567f44bf89015ce23a786a14b585f21cb6e99929bf0a9a0b18"
    sha256 cellar: :any_skip_relocation, catalina:       "a35973d863752b567f44bf89015ce23a786a14b585f21cb6e99929bf0a9a0b18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38ad9ddf6c3686dd6b9175503ebf94e6e4e4918931d8cbd41fe85912c507ccef"
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
