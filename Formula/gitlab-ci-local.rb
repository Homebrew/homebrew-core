require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.39.1.tgz"
  sha256 "28ec1fbcf87d7306b0e3042490d67d4f3bb53012663bc504fbbfc839a74b829c"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d460833bd05dd962a4e42c0adbc8cae7cfa6b4de7d8abb00199a97baa4dc834"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d460833bd05dd962a4e42c0adbc8cae7cfa6b4de7d8abb00199a97baa4dc834"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d460833bd05dd962a4e42c0adbc8cae7cfa6b4de7d8abb00199a97baa4dc834"
    sha256 cellar: :any_skip_relocation, ventura:        "d7e8636cd31eb2a1e88f36b79daafb875552ce77a0eb7a695115456afe1dd659"
    sha256 cellar: :any_skip_relocation, monterey:       "d7e8636cd31eb2a1e88f36b79daafb875552ce77a0eb7a695115456afe1dd659"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7e8636cd31eb2a1e88f36b79daafb875552ce77a0eb7a695115456afe1dd659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d460833bd05dd962a4e42c0adbc8cae7cfa6b4de7d8abb00199a97baa4dc834"
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
