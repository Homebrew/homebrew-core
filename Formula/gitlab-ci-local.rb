require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.33.1.tgz"
  sha256 "2978670e8063aa8aba1c9d09c6e3bac89311cd5a92dd0c771c81048df2e9c1e1"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00dec8db5971dcd70fe5a305147afe5136b1a0b227e2f3ff284a9661d36f9c99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00dec8db5971dcd70fe5a305147afe5136b1a0b227e2f3ff284a9661d36f9c99"
    sha256 cellar: :any_skip_relocation, monterey:       "5bd86e2f41ee49b0dc93dc92b41b683cd62b626f78d25dd3915e3b33b7a78ad5"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bd86e2f41ee49b0dc93dc92b41b683cd62b626f78d25dd3915e3b33b7a78ad5"
    sha256 cellar: :any_skip_relocation, catalina:       "5bd86e2f41ee49b0dc93dc92b41b683cd62b626f78d25dd3915e3b33b7a78ad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00dec8db5971dcd70fe5a305147afe5136b1a0b227e2f3ff284a9661d36f9c99"
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
