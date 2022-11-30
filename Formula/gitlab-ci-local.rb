require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.36.1.tgz"
  sha256 "c9cf822a1a0a8550eb13339436ca3a3e2df49e09a855baead332861a606fc592"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0287072c69871b3a00e32e810e4f53926bf013383d7627ea05580d5b0480ed46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0287072c69871b3a00e32e810e4f53926bf013383d7627ea05580d5b0480ed46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0287072c69871b3a00e32e810e4f53926bf013383d7627ea05580d5b0480ed46"
    sha256 cellar: :any_skip_relocation, ventura:        "8504b1ccf9cee92582473fa076d244b8cc79ee2da0ba5a3e40e9b0e14ef4edda"
    sha256 cellar: :any_skip_relocation, monterey:       "8504b1ccf9cee92582473fa076d244b8cc79ee2da0ba5a3e40e9b0e14ef4edda"
    sha256 cellar: :any_skip_relocation, big_sur:        "8504b1ccf9cee92582473fa076d244b8cc79ee2da0ba5a3e40e9b0e14ef4edda"
    sha256 cellar: :any_skip_relocation, catalina:       "8504b1ccf9cee92582473fa076d244b8cc79ee2da0ba5a3e40e9b0e14ef4edda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0287072c69871b3a00e32e810e4f53926bf013383d7627ea05580d5b0480ed46"
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
