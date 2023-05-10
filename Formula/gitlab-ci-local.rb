require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.40.1.tgz"
  sha256 "278978d9a3cf69e2f5fd8afb88ca2445b4e568d0461f4a35a7a58c7743c685ba"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cce4f2efe705a5c7eb9c18b0503facd6d253954b138f8821a2f41c2d0d3f7157"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cce4f2efe705a5c7eb9c18b0503facd6d253954b138f8821a2f41c2d0d3f7157"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cce4f2efe705a5c7eb9c18b0503facd6d253954b138f8821a2f41c2d0d3f7157"
    sha256 cellar: :any_skip_relocation, ventura:        "d3a2382b2f72e394e71c94cadf3ac7a14bb4eb38ab0301fe32924eb518cae32d"
    sha256 cellar: :any_skip_relocation, monterey:       "d3a2382b2f72e394e71c94cadf3ac7a14bb4eb38ab0301fe32924eb518cae32d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3a2382b2f72e394e71c94cadf3ac7a14bb4eb38ab0301fe32924eb518cae32d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cce4f2efe705a5c7eb9c18b0503facd6d253954b138f8821a2f41c2d0d3f7157"
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
