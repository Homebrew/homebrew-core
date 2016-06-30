require "language/go"

class GitlabCiMultiRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner"
  url "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git",
    :tag => "v1.3.2",
    :revision => "032345623f4094450c9e78dc1744365164ab6dba"
  head "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "97a38c499122942ae1da5702801f7887b604dd0cbd984fdafdcc3b91a80f5d70" => :el_capitan
    sha256 "e8aa7bd0159b1a9a870efa77c0a621a99b3dbc90830e22950e9ae2f7c287fa96" => :yosemite
    sha256 "e537118330625813cad98e072ffc1a456193a6faa756a4db4de08e2fd298b61e" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build
  depends_on "docker" => :recommended

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
      :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  resource "prebuilt-x86_64.tar.gz" do
    url "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v1.3.2/docker/prebuilt-x86_64.tar.gz",
      :using => :nounzip
    sha256 "8f4218c357ae8e34a81ed3a4d86e4a24ede2295e71edf659282fd4a4badbada7"
  end

  def install
    mkdir_p buildpath/"src/gitlab.com/gitlab-org"
    ln_sf buildpath, buildpath/"src/gitlab.com/gitlab-org/gitlab-ci-multi-runner"

    ENV["GOPATH"] = buildpath

    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Go.stage_deps resources, buildpath/"src"

    cd buildpath/"src/github.com/jteeuwen/go-bindata/go-bindata" do
      system "go", "install"
    end

    resource("prebuilt-x86_64.tar.gz").stage do
      system "go-bindata", "-pkg", "docker", "-nocompress", "-nomemcopy", "-nometadata", "-o", buildpath/"executors/docker/bindata.go", "prebuilt-x86_64.tar.gz"
    end

    cd "src/gitlab.com/gitlab-org/gitlab-ci-multi-runner" do
      commit_sha = `git rev-parse --short HEAD`

      # Disable vendor support for go 1.5 and above
      ENV["GO15VENDOREXPERIMENT"] = "0"

      # Copy from Makefile
      system "godep", "go", "build", "-o", "gitlab-ci-multi-runner", "-ldflags", "-X main.NAME=gitlab-ci-multi-runner -X main.VERSION=#{version} -X main.REVISION=#{commit_sha}"
      bin.install "gitlab-ci-multi-runner"
      bin.install_symlink "#{bin}/gitlab-ci-multi-runner" => "gitlab-runner"
    end
  end

  test do
    assert_match "Version:      #{version}", shell_output("#{bin}/gitlab-ci-multi-runner --version")
    assert_match "Version:      #{version}", shell_output("#{bin}/gitlab-runner --version")
  end
end
