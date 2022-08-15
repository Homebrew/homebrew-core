require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.33.0.tgz"
  sha256 "bf5583b0b08df968a4db07fd4bc8211f7304984fca64d6b230df0be3dc8f5984"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3158e3bb55a47d75bbee9e68a09c46b3ec2a708d793eab482dbe0ba3aef15d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3158e3bb55a47d75bbee9e68a09c46b3ec2a708d793eab482dbe0ba3aef15d6"
    sha256 cellar: :any_skip_relocation, monterey:       "7d0de80996ca5247a7eefc2340be4c1386687bdc3a7cf2f32bb5fd0e6b91e9eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d0de80996ca5247a7eefc2340be4c1386687bdc3a7cf2f32bb5fd0e6b91e9eb"
    sha256 cellar: :any_skip_relocation, catalina:       "7d0de80996ca5247a7eefc2340be4c1386687bdc3a7cf2f32bb5fd0e6b91e9eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3158e3bb55a47d75bbee9e68a09c46b3ec2a708d793eab482dbe0ba3aef15d6"
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
