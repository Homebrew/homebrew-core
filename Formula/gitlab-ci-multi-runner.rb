require "language/go"

class GitlabCiMultiRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner"
  url "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git",
      :tag => "v1.8.1",
      :revision => "a2efdd470c19e69223f9cb3af2c0c95e5f9ce002"
  head "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "36c152b1a149de363cc4e1f385eecc628cfa5a9db9d5d6cf366131c1a45ed05c" => :sierra
    sha256 "d4617f38f4c21c2db8249d3be827860aba5d43232b3e42b926ad5bc261f1130a" => :el_capitan
    sha256 "1c46df42482e42c14364943a31c962dd7f304f1472bc671e4e008bf15891943f" => :yosemite
  end

  depends_on "go" => :build
  depends_on "docker" => :recommended

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
        :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  resource "prebuilt-x86_64.tar.xz" do
    url "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v1.8.1/docker/prebuilt-x86_64.tar.xz",
        :using => :nounzip
    version "1.8.1"
    sha256 "c350e7d385894aae8b247ffcf3fd2034ac7ac1adc9b64d3d761243966b8920a5"
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
        system "go-bindata", "-pkg", "docker", "-nocompress", "-nomemcopy",
                             "-nometadata", "-o",
                             "#{dir}/executors/docker/bindata.go",
                             "prebuilt-x86_64.tar.xz"
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
