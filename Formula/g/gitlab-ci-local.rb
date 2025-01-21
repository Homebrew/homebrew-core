class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.56.2.tgz"
  sha256 "97895a6f81f50ac0ff6eda4c807453ac7fc4608de634d993f954743caf1a5cd9"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "a9287020bc812e18eeb3bd14cb2ba59f88c4262baf37e9983d0bf26cace5ed33"
    sha256                               arm64_sonoma:  "e51168ff943f17a8f4628920211216cdd9f663be61144fc6cc73cdaa17604856"
    sha256                               arm64_ventura: "d5f1e2ab6f047a80245fd42f926bd2f0b8086b88312d5867907475a3d7da6194"
    sha256                               sonoma:        "4dfed5ba030d7e9696ab35e745420ad6da7b455e5d55f53ae7c717858b5c6786"
    sha256                               ventura:       "e5bf5865eb74a943af7ed605c2a385d6b622e4dd50839fe288c74c01491f8989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61e879b5e864e313ef9fa653892ac7b5840abd59cc52dcefff010cfc83511594"
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
