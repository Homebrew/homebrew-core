require "language/go"

class GitlabCiMultiRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner"
  url "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git",
      :tag => "v1.10.5",
      :revision => "8bebc163b8a8e6811b74e690faa2464167f1efd9"
  head "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e2dcee0afbba8ba62924b0eabdc2996e74886f8dea0957cbde10598a1162dbf" => :sierra
    sha256 "bcd132f379a0a15969e66c302a7507732a2d1665b4d61ad24b6f0f4c48aa18b2" => :el_capitan
    sha256 "fa11d38f6d9884e186002f5d82063b7c03c93bee7ec8ff9f4b22b18e0978ddb1" => :yosemite
  end

  depends_on "go" => :build
  depends_on "docker" => :recommended

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
        :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  resource "prebuilt-x86_64.tar.xz" do
    url "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v1.10.5/docker/prebuilt-x86_64.tar.xz",
        :using => :nounzip
    version "1.10.5"
    sha256 "317926f94ed13bcc1027c75ab4911e495dd7f69713f8e90151e44194e68293e1"
  end

  resource "prebuilt-arm.tar.xz" do
    url "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v1.10.5/docker/prebuilt-arm.tar.xz",
        :using => :nounzip
    version "1.10.5"
    sha256 "287f278285b0b4fdf13d8e05aaa5cc189b63b901b64721039e80a9c89f2d148a"
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
