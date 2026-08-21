class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.74.0.tgz"
  sha256 "3ba6f49dda54b68d73762eb6950f6ab5ec84c77dfa114e6e509b769db54abd82"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a4d1969a3a76abee1896e82b2c49e3c2b87328fbfac98cb241d8582f4df1e28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a4d1969a3a76abee1896e82b2c49e3c2b87328fbfac98cb241d8582f4df1e28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a4d1969a3a76abee1896e82b2c49e3c2b87328fbfac98cb241d8582f4df1e28"
    sha256 cellar: :any_skip_relocation, sonoma:        "92e12df571b8f772e90c14cfe60354bc87bfe2291913513db5fe29f06b3e7d12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92e12df571b8f772e90c14cfe60354bc87bfe2291913513db5fe29f06b3e7d12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92e12df571b8f772e90c14cfe60354bc87bfe2291913513db5fe29f06b3e7d12"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"gitlab-ci-local", "--completion", shell_parameter_format: :none,
                                                                                shells:                 [:bash, :zsh])
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

    assert_match(/name\s*?description\s*?stage\s*?when\s*?allow_failure\s*?environment\s*?needs\n/,
        shell_output("#{bin}/gitlab-ci-local --list"))
  end
end
