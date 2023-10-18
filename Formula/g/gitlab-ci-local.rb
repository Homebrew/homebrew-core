require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.44.0.tgz"
  sha256 "ebcbae723b6fd2317cc79a2c422b678a3a7051e1bb7f4050d62b5cbd9ac20c67"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f48ca6c21777ebfab2a9ab1daac94d16a8dc6bef29899bca3c47473654851d9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f48ca6c21777ebfab2a9ab1daac94d16a8dc6bef29899bca3c47473654851d9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f48ca6c21777ebfab2a9ab1daac94d16a8dc6bef29899bca3c47473654851d9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "fcc70061b78db1424a330f68f26ed80e8e9d30e080fc5b84e6b97aff5efb2ae2"
    sha256 cellar: :any_skip_relocation, ventura:        "fcc70061b78db1424a330f68f26ed80e8e9d30e080fc5b84e6b97aff5efb2ae2"
    sha256 cellar: :any_skip_relocation, monterey:       "fcc70061b78db1424a330f68f26ed80e8e9d30e080fc5b84e6b97aff5efb2ae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f48ca6c21777ebfab2a9ab1daac94d16a8dc6bef29899bca3c47473654851d9b"
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
