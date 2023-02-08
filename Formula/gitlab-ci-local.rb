require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.38.1.tgz"
  sha256 "5259a007acbce0e6d93ee18ebbecdf344b19240ece0b23251baa00647eba71f2"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3133150422e84d5be09d4107e99c4cc7ed015a261b1d983b371d5e873af1315f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3133150422e84d5be09d4107e99c4cc7ed015a261b1d983b371d5e873af1315f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3133150422e84d5be09d4107e99c4cc7ed015a261b1d983b371d5e873af1315f"
    sha256 cellar: :any_skip_relocation, ventura:        "778382b28c6d7c8c8ec9ad9b194b9c6e5d545b8e85b857277c16e02c3a1df04a"
    sha256 cellar: :any_skip_relocation, monterey:       "778382b28c6d7c8c8ec9ad9b194b9c6e5d545b8e85b857277c16e02c3a1df04a"
    sha256 cellar: :any_skip_relocation, big_sur:        "778382b28c6d7c8c8ec9ad9b194b9c6e5d545b8e85b857277c16e02c3a1df04a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3133150422e84d5be09d4107e99c4cc7ed015a261b1d983b371d5e873af1315f"
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
