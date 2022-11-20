require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.35.0.tgz"
  sha256 "ef598aefcf5d03c7ddb98f64191b433181264f56abcaa0386eb3b7f54bfbd2cf"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d92955453321878f92efa036e11324d95776f9099da5a746049144d041b84bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d92955453321878f92efa036e11324d95776f9099da5a746049144d041b84bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d92955453321878f92efa036e11324d95776f9099da5a746049144d041b84bc"
    sha256 cellar: :any_skip_relocation, ventura:        "caa83094fd1c6754e2ed9f6e23b4b45c7d3eccac5910d474cfe74db742152b27"
    sha256 cellar: :any_skip_relocation, monterey:       "caa83094fd1c6754e2ed9f6e23b4b45c7d3eccac5910d474cfe74db742152b27"
    sha256 cellar: :any_skip_relocation, big_sur:        "caa83094fd1c6754e2ed9f6e23b4b45c7d3eccac5910d474cfe74db742152b27"
    sha256 cellar: :any_skip_relocation, catalina:       "caa83094fd1c6754e2ed9f6e23b4b45c7d3eccac5910d474cfe74db742152b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d92955453321878f92efa036e11324d95776f9099da5a746049144d041b84bc"
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
