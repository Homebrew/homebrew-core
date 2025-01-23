class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.57.0.tgz"
  sha256 "9a86c4e8ab6a8e0617b9244c100f50eddd272a9f080c370607cd993e24c8c45e"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "c554226dcc01a2b63a7692aa2b44d70b4cc707f7fc15902f4502a6359c5a692a"
    sha256                               arm64_sonoma:  "dc5482ed2feb9841fc1f26457f3e0f570f1d47523dab77a439e372be836aad4e"
    sha256                               arm64_ventura: "2570917dd299c4ef3354ab8d70c7509be56c7d2d0af624b5042aba0e32d25d6d"
    sha256                               sonoma:        "05c77cb4111fccddbf1c9ae21cc8dad185915dbd2c22b62b57d4f9d815bb5ed2"
    sha256                               ventura:       "0664b3036f576b3454e1eb4c8ecdb4115a4bcd06aed4bb517d241d202937bae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac1f3233695e3223a14a8a2468e509d069d346c8b0a87cdda98ad15266d5dca9"
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
