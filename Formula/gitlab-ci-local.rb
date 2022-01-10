require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.28.1.tgz"
  sha256 "f2cc42cf956f32605acce41307782f3aff5351f15f9babc7ab24cad9cd4ec30f"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b82df4194cc0ba8ad1fb8f6ef05b4114ece58546d339806d8452351469223140"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b82df4194cc0ba8ad1fb8f6ef05b4114ece58546d339806d8452351469223140"
    sha256 cellar: :any_skip_relocation, monterey:       "d4f6a8218fb70613fc7fc1aa37d4d0eb11392a056c8097035b37420c8592321e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4f6a8218fb70613fc7fc1aa37d4d0eb11392a056c8097035b37420c8592321e"
    sha256 cellar: :any_skip_relocation, catalina:       "d4f6a8218fb70613fc7fc1aa37d4d0eb11392a056c8097035b37420c8592321e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b82df4194cc0ba8ad1fb8f6ef05b4114ece58546d339806d8452351469223140"
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
