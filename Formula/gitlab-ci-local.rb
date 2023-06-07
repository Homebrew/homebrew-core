require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.41.2.tgz"
  sha256 "336ee649bf9698e7b30ccda369b39664dd3b6617e3ef9797f7e4f50cb26dff46"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f0c458ede1acc12fabefb435162666256236d44c3e844becdde9f0314c592ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f0c458ede1acc12fabefb435162666256236d44c3e844becdde9f0314c592ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f0c458ede1acc12fabefb435162666256236d44c3e844becdde9f0314c592ea"
    sha256 cellar: :any_skip_relocation, ventura:        "97b15425a3ea3d3bef8d318876fe4d20f7fd45e8bc0ed45c39d2c451366b6d6a"
    sha256 cellar: :any_skip_relocation, monterey:       "97b15425a3ea3d3bef8d318876fe4d20f7fd45e8bc0ed45c39d2c451366b6d6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "97b15425a3ea3d3bef8d318876fe4d20f7fd45e8bc0ed45c39d2c451366b6d6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f0c458ede1acc12fabefb435162666256236d44c3e844becdde9f0314c592ea"
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
