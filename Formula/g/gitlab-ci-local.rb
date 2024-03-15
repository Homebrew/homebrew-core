require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.47.0.tgz"
  sha256 "54979ce76f9539651bcb2597007861be7ee7578e2b19f7e6f91a1cd34b5cb730"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36ff1417be6a5ce205649240938cc7f90126133f5140d3e4d77fc9816dbb23de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36ff1417be6a5ce205649240938cc7f90126133f5140d3e4d77fc9816dbb23de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36ff1417be6a5ce205649240938cc7f90126133f5140d3e4d77fc9816dbb23de"
    sha256 cellar: :any_skip_relocation, sonoma:         "46d5e2045bdbc988bb39cc0a3f37aaeb6d2d4f3bf81078f35ea79c9db6c05834"
    sha256 cellar: :any_skip_relocation, ventura:        "46d5e2045bdbc988bb39cc0a3f37aaeb6d2d4f3bf81078f35ea79c9db6c05834"
    sha256 cellar: :any_skip_relocation, monterey:       "46d5e2045bdbc988bb39cc0a3f37aaeb6d2d4f3bf81078f35ea79c9db6c05834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36ff1417be6a5ce205649240938cc7f90126133f5140d3e4d77fc9816dbb23de"
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
