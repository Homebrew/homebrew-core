require "language/go"

class GitlabCiMultiRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner"
  url "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git",
    :tag => "v1.4.0",
    :revision => "5dd9b2fdfe118bd146b06f905dfa0f3346e2a575"
  head "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d57de95a63af132f8a0db2dc994d01063180d58e95d981aa4714108371fa08cc" => :el_capitan
    sha256 "db6b30291c2170f3a8e9911b8acc979aca5976516f7c89d734ea8f039ff5f29b" => :yosemite
    sha256 "355b06fb8e9861789e2848eb465856801fb4663e417772b99d24dc049a5cfb26" => :mavericks
  end

  depends_on "go" => :build
  depends_on "docker" => :recommended

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
      :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  resource "prebuilt-x86_64.tar.gz" do
    url "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v1.4.0/docker/prebuilt-x86_64.tar.gz",
      :using => :nounzip
    version "1.4.0"
    sha256 "01246d4b97ff91e3ce7de258bf0987bee265ed71d647e5dbf10b104b7073a645"
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
      branch = Utils.popen_read("git", "name-rev", "--name-only", "HEAD")
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
