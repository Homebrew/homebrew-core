require "language/go"

class GitlabCiMultiRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner"
  url "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git",
    :tag => "v1.1.2",
    :revision => "78b3f826a6124dc20bb94f1c2d9b0c0bac26fef7"
  revision 1

  head "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "41058a0ab27e231811c577f12077658e1e78a0c3785b2b7c05314c19a083025d" => :el_capitan
    sha256 "33cbe973170b5186c76478d37bae80d738d3b2a20ce6c4fca57258f2201de408" => :yosemite
    sha256 "94949fb457729824358dde3448895efe478f764c47a31b8e0cf756bf082d6e27" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build
  depends_on "docker" => :recommended

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
      :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  resource "prebuilt.tar.gz" do
    url "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v1.1.2/docker/prebuilt.tar.gz",
      :using => :nounzip
    sha256 "ad692bf548f3f55967c86b71b3aeaa9cc82cd156554a546753b0829a36219b98"
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

    resource("prebuilt.tar.gz").stage do
      system "go-bindata", "-pkg", "docker", "-nocompress", "-nomemcopy", "-nometadata", "-o", buildpath/"executors/docker/bindata.go", "prebuilt.tar.gz"
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
    assert_match "gitlab-ci-multi-runner version #{version}", shell_output("#{bin}/gitlab-ci-multi-runner --version")
    assert_match "gitlab-runner version #{version}", shell_output("#{bin}/gitlab-runner --version")
  end
end
