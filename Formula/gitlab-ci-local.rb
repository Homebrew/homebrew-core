require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.26.1.tgz"
  sha256 "1e7d7cedf95fdda9292b63a8663a3da4b515e57298cf8bde08e784ecb310caa7"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc562d94723c2df60d2dd998882091ef43a2301bf80fcd87abd11ab0808861c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc562d94723c2df60d2dd998882091ef43a2301bf80fcd87abd11ab0808861c0"
    sha256 cellar: :any_skip_relocation, monterey:       "672510c3715fdf146f16a054f6d1f5b10341d53bf40206eca16b596dce6ed3fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "672510c3715fdf146f16a054f6d1f5b10341d53bf40206eca16b596dce6ed3fb"
    sha256 cellar: :any_skip_relocation, catalina:       "672510c3715fdf146f16a054f6d1f5b10341d53bf40206eca16b596dce6ed3fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc562d94723c2df60d2dd998882091ef43a2301bf80fcd87abd11ab0808861c0"
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

    assert_equal shell_output("#{bin}/gitlab-ci-local --list"), <<~OUTPUT
      name              description  stage  when        allow_failure  needs
      build                          build  on_success  false          []
      tag-docker-image               tag    on_success  false          [build]
    OUTPUT
  end
end
