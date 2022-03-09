require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.29.0.tgz"
  sha256 "266b308d29e0a9099d0ba8e5a0fd88479930e465a87dec0c783cd8d5b616848f"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8c71429bc8f7db9a1d9794d64189d7c612eff196ba017a53823eb3beffd9607"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8c71429bc8f7db9a1d9794d64189d7c612eff196ba017a53823eb3beffd9607"
    sha256 cellar: :any_skip_relocation, monterey:       "7972aca63dc2bad87962f4a970b80daafe7571972feed4e18c634b83fa947f6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7972aca63dc2bad87962f4a970b80daafe7571972feed4e18c634b83fa947f6a"
    sha256 cellar: :any_skip_relocation, catalina:       "7972aca63dc2bad87962f4a970b80daafe7571972feed4e18c634b83fa947f6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8c71429bc8f7db9a1d9794d64189d7c612eff196ba017a53823eb3beffd9607"
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
