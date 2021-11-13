require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.26.3.tgz"
  sha256 "14ddc181777100e05d2623deb867d19e091036343a42f55796869f721f9473ce"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afeb5e19bdc3ac585598dbcc46ae1818c03c4583ff08dee4401ef9317ca780c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afeb5e19bdc3ac585598dbcc46ae1818c03c4583ff08dee4401ef9317ca780c3"
    sha256 cellar: :any_skip_relocation, monterey:       "48630fd41b74c95fdf566fbfffdf087bc8b62c1e69810d51422a9ac24b9aadfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "48630fd41b74c95fdf566fbfffdf087bc8b62c1e69810d51422a9ac24b9aadfc"
    sha256 cellar: :any_skip_relocation, catalina:       "48630fd41b74c95fdf566fbfffdf087bc8b62c1e69810d51422a9ac24b9aadfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afeb5e19bdc3ac585598dbcc46ae1818c03c4583ff08dee4401ef9317ca780c3"
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
