class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.58.0.tgz"
  sha256 "ad42eac5b9c372675771c718e1dbccf98069cee47cd9c1f89c3f670496d1b7e1"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "a38b268bbd7e64676188d95108683280aac1a6ee9348c79a1c2f3d4210446aec"
    sha256                               arm64_sonoma:  "1a270da6cd4cc27072ee28812487dc645340a17992c574ee5f8099040ab52ffd"
    sha256                               arm64_ventura: "8184c017a04e94a0dcc5a88698c8b5483525fbbf352dfedf21aeb4b37aff70c7"
    sha256                               sonoma:        "b633e3249419bcff292b6d7e62bba044ef10dead3465b00201f33ba8ae994fc6"
    sha256                               ventura:       "6298de2ebc161af2e6297451ab7beaf7f06436d2dbaed664708c7b7c0f0f2ae7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5305680f8165adcbe0d566518c4090d2cffeec65a6ae2ded8fe28ec34a060257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f42bb808b7fc933e73d2de971a833d1e441a93b82dbe3570b769fd8edea141c5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
