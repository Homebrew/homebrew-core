require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.49.0.tgz"
  sha256 "b39c13675240f88041b703b4fdae2a09b040db640d33fb9aaaa0d58aa8114d5d"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a32dbf10dd360fca0cf2b565448ac3792aa7c8b24e2f56d6c62a58f372d2b29"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b8a243a6aa65f669346da81a3cc7bb56a533b607e9c414c1fef5735f241f3d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "654914c67ef2a8081f19dabb0a2ff755508af4fa20da45b7d2d9c22b6bfb1a49"
    sha256 cellar: :any_skip_relocation, sonoma:         "8185b49ba40a583070a16a11d625e407aa6fb0aa7170eb36cb8bbc8238633dfd"
    sha256 cellar: :any_skip_relocation, ventura:        "5cf81f6a63c44d2ea5f002c2783101ed89322869141632e9482226c051404f85"
    sha256 cellar: :any_skip_relocation, monterey:       "44d207b2c0f4730d52dfaf00a3ecd4475730d8a75e1ed867840c4adb25cc4e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4df9bffc06406839602afd1c4f3237e503ceece264d578b5208a86daed691ee8"
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
