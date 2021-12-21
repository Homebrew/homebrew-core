require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.28.0.tgz"
  sha256 "edc28c090af3a3342b767e22e65930fd48b4df2d91e6041fb755631dfcfc3a11"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2e4f9eb718249c01846b2885f693755acd1c7efa5751e3cf762fa3ab3bc15f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2e4f9eb718249c01846b2885f693755acd1c7efa5751e3cf762fa3ab3bc15f5"
    sha256 cellar: :any_skip_relocation, monterey:       "6dfa31c65fb37c47cf848be4d7ef7f47254a0b19de16b87f2cedd2c299ccf69d"
    sha256 cellar: :any_skip_relocation, big_sur:        "6dfa31c65fb37c47cf848be4d7ef7f47254a0b19de16b87f2cedd2c299ccf69d"
    sha256 cellar: :any_skip_relocation, catalina:       "6dfa31c65fb37c47cf848be4d7ef7f47254a0b19de16b87f2cedd2c299ccf69d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2e4f9eb718249c01846b2885f693755acd1c7efa5751e3cf762fa3ab3bc15f5"
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
