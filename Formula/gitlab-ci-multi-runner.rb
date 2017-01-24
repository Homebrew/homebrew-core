require "language/go"

class GitlabCiMultiRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner"
  url "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git",
      :tag => "v1.10.1",
      :revision => "1039add9a4697c46b61f8b4ad8b2941230cc7445"
  head "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git"

  bottle do
    sha256 "d52bead368b9a370f9ecc0550a03d202f4885b23747f7720c86a98ca8b34b316" => :sierra
    sha256 "8488db683f359ceb315e874ae2baac48dc2af01cd843cd15b9bc6f42eebee230" => :el_capitan
    sha256 "fb7ef79d07a2b9c1558dc24d2fb5c557a7dff0a8e7c7c4ff29fcbd94f6d17707" => :yosemite
  end

  depends_on "go" => :build
  depends_on "docker" => :recommended

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
        :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  resource "prebuilt-x86_64.tar.xz" do
    url "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v1.10.1/docker/prebuilt-x86_64.tar.xz",
        :using => :nounzip
    version "1.10.1"
    sha256 "df86ee6ecd2cbcf86d68e9edbcb860531e6aef4ef80dbdc9747cd9dab6536b90"
  end

  resource "prebuilt-arm.tar.xz" do
    url "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v1.10.1/docker/prebuilt-arm.tar.xz",
        :using => :nounzip
    version "1.10.1"
    sha256 "1f1563293f82830ce54dcc1d40c4b1d152e015a2aaf1b2eee709815b8bd2a816"
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
      Pathname.pwd.install resource("prebuilt-x86_64.tar.xz"),
                           resource("prebuilt-arm.tar.xz")
      system "go-bindata", "-pkg", "docker", "-nocompress", "-nomemcopy",
                           "-nometadata", "-o",
                           "#{dir}/executors/docker/bindata.go",
                           "prebuilt-x86_64.tar.xz",
                           "prebuilt-arm.tar.xz"

      proj = "gitlab.com/gitlab-org/gitlab-ci-multi-runner"
      commit = Utils.popen_read("git", "rev-parse", "--short", "HEAD").chomp
      branch = version.to_s.split(".")[0..1].join("-") + "-stable"
      built = Time.new.strftime("%Y-%m-%dT%H:%M:%S%:z")
      system "go", "build", "-ldflags", <<-EOS.undent
             -X #{proj}/common.NAME=gitlab-ci-multi-runner
             -X #{proj}/common.VERSION=#{version}
             -X #{proj}/common.REVISION=#{commit}
             -X #{proj}/common.BRANCH=#{branch}
             -X #{proj}/common.BUILT=#{built}
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
