require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.28.1.tgz"
  sha256 "f2cc42cf956f32605acce41307782f3aff5351f15f9babc7ab24cad9cd4ec30f"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2baa7063b9c7482993149c54ff27cd43b715d6613d0a622f10eb61268a2421bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2baa7063b9c7482993149c54ff27cd43b715d6613d0a622f10eb61268a2421bd"
    sha256 cellar: :any_skip_relocation, monterey:       "9b1e0365941b66414e72036d8aa3b65f7a3918e7be8d8f2f39abc05d805c155a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b1e0365941b66414e72036d8aa3b65f7a3918e7be8d8f2f39abc05d805c155a"
    sha256 cellar: :any_skip_relocation, catalina:       "9b1e0365941b66414e72036d8aa3b65f7a3918e7be8d8f2f39abc05d805c155a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2baa7063b9c7482993149c54ff27cd43b715d6613d0a622f10eb61268a2421bd"
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
