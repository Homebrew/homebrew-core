require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.48.2.tgz"
  sha256 "3eefb079c1abe9e79c0d1a3466921d5a08375ead27fffa7e392e6fcb6d2eb1dd"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b32d7709b12e712d990b293bee632b6a0aa2ce53d22e9df0d20adf4f68d24a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b32d7709b12e712d990b293bee632b6a0aa2ce53d22e9df0d20adf4f68d24a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b32d7709b12e712d990b293bee632b6a0aa2ce53d22e9df0d20adf4f68d24a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "efad80ae211eaee22e83546fdb52f3437aadbf438f821e9af92939e0c95792b9"
    sha256 cellar: :any_skip_relocation, ventura:        "efad80ae211eaee22e83546fdb52f3437aadbf438f821e9af92939e0c95792b9"
    sha256 cellar: :any_skip_relocation, monterey:       "efad80ae211eaee22e83546fdb52f3437aadbf438f821e9af92939e0c95792b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b32d7709b12e712d990b293bee632b6a0aa2ce53d22e9df0d20adf4f68d24a4"
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
