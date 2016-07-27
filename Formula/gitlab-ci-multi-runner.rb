require "language/go"

class GitlabCiMultiRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner"
  url "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git",
    :tag => "v1.4.1",
    :revision => "fae8f189cd367d870c3d41471ba569070acee2e1"
  head "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e53560eaaa87ad35190bf7c91bf065e9716f17e49ebd522cd075722afeeecce0" => :el_capitan
    sha256 "e9e80e854a1da2c3190a50eb04d9ac8842384f5e15e2e8f683cdf41e75748671" => :yosemite
    sha256 "65950a28a0308fdb1c326fe52bbfcdfc66b356a222888e057266e50acb306105" => :mavericks
  end

  depends_on "go" => :build
  depends_on "docker" => :recommended

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
      :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  resource "prebuilt-x86_64.tar.gz" do
    url "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v1.4.1/docker/prebuilt-x86_64.tar.gz",
      :using => :nounzip
    version "1.4.1"
    sha256 "297a732c527a272635b49fba8b91e32a04404b2be696be77206a269acd1c97ff"
  end

  def install
    ENV["GOPATH"] = buildpath
    proj = "gitlab.com/gitlab-org/gitlab-ci-multi-runner"
    dir = buildpath/"src/#{proj}"
    dir.install buildpath.children
    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Go.stage_deps resources, buildpath/"src"

    cd buildpath/"src/github.com/jteeuwen/go-bindata/go-bindata" do
      system "go", "install"
    end

    cd dir do
      resource("prebuilt-x86_64.tar.gz").stage do
        system "go-bindata", "-pkg", "docker",
               "-nocompress", "-nomemcopy", "-nometadata",
               "-o", dir/"executors/docker/bindata.go",
               "prebuilt-x86_64.tar.gz"
      end

      commit = Utils.popen_read("git", "rev-parse", "--short", "HEAD")
      branch = Utils.popen_read("git", "branch", "-a", "--contains", "HEAD")
      branch = branch[/remotes\/origin\/([a-zA-Z1-9-]+)\n/]
      ldflags = %W[
        --ldflags=
        -X #{proj}/common.NAME=gitlab-ci-multi-runner
        -X #{proj}/common.VERSION=#{version}
        -X #{proj}/common.REVISION=#{commit}
        -X #{proj}/common.BRANCH=#{branch.strip_prefix("remotes/origin/").chomp}
      ]
      system "go", "build", ldflags.join(" ")
      bin.install "gitlab-ci-multi-runner"
      bin.install_symlink bin/"gitlab-ci-multi-runner" => "gitlab-runner"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "Version:      #{version}", shell_output("#{bin}/gitlab-ci-multi-runner --version")
    assert_match "Version:      #{version}", shell_output("#{bin}/gitlab-runner --version")
  end
end
