class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.60.1.tgz"
  sha256 "2945d0322fd00ab9b734c6bda95a23b29162a906048ca8bda394466cb75a2f68"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8df418f3d52221f021eccfde1ac3feb75cec1f14491b3b0015437c3f6ab795e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8df418f3d52221f021eccfde1ac3feb75cec1f14491b3b0015437c3f6ab795e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8df418f3d52221f021eccfde1ac3feb75cec1f14491b3b0015437c3f6ab795e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8164c92a39c20fda63c5a14e6b2560b6c91b2db7635ac212e4d623746354f930"
    sha256 cellar: :any_skip_relocation, ventura:       "8164c92a39c20fda63c5a14e6b2560b6c91b2db7635ac212e4d623746354f930"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "001682515a95f8b8113ea08519e02c65b6a008debd67965ed7fc9adb6f0b1e8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa5a41c2900efcd4c9a01c2b0fbf41359d4f401b37844222182feb7685cd4ae8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/".gitlab-ci.yml").write <<~YAML
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
    YAML

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
