require "language/go"

class GitlabCiMultiRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner"
  url "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git",
    :tag => "v1.5.2",
    :revision => "76fdacdf55c5a83249a4bdc5bd8c650e7a5ff796"
  head "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "05a33892b2bb48bcaa8ff3e19efc88e3fb8aeaf5ee56c7e2ebcff9620f2b20a7" => :el_capitan
    sha256 "bbf00b7b1efc1ba7ead9bb870c7df099319023f3f018851798107a9ca897ff3d" => :yosemite
    sha256 "9fd31f0a3127262bc6cd5064ff4081a1af77a20e63b70917425ff63f68baca9e" => :mavericks
  end

  depends_on "go" => :build
  depends_on "docker" => :recommended

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
      :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  resource "prebuilt-x86_64.tar.xz" do
    url "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v1.5.2/docker/prebuilt-x86_64.tar.xz",
      :using => :nounzip
    version "1.5.2"
    sha256 "265a49a8ecb5a4ca3fe51c66baca2a8e82608e37fbe487e261bfe72d83dc5902"
  end

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/gitlab.com/gitlab-org/gitlab-ci-multi-runner"
    dir.install buildpath.children
    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/jteeuwen/go-bindata/go-bindata" do
      system "go", "install"
    end

    cd dir do
      resource("prebuilt-x86_64.tar.xz").stage do
        system *%W[go-bindata -pkg docker -nocompress -nomemcopy -nometadata
                   -o #{dir}/executors/docker/bindata.go prebuilt-x86_64.tar.xz]
      end

      proj = "gitlab.com/gitlab-org/gitlab-ci-multi-runner"
      commit = Utils.popen_read("git", "rev-parse", "--short", "HEAD").chomp
      branch = version.to_s.split(".")[0..1].join("-") + "-stable"
      system "go", "build", "-ldflags", <<-EOS.undent
             -X #{proj}/common.NAME=gitlab-ci-multi-runner
             -X #{proj}/common.VERSION=#{version}
             -X #{proj}/common.REVISION=#{commit}
             -X #{proj}/common.BRANCH=#{branch}
      EOS

      bin.install "gitlab-ci-multi-runner"
      bin.install_symlink bin/"gitlab-ci-multi-runner" => "gitlab-runner"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
