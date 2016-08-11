require "language/go"

class GitlabCiMultiRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner"
  url "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git",
    :tag => "v1.4.2",
    :revision => "bcc1794f6dd7edf8e3984bfbf37c2baf9887f03a"
  head "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b21543cb6cf82656e325aecbf82e0e7febeed1877b63581d5967c5ed441e82af" => :el_capitan
    sha256 "f28d8e0a677d382f643e51dc869e6bb309bd5dedd26e17a6254ba89cb45e9059" => :yosemite
    sha256 "b34cceead147eae07026264022f86e0a92cccf1245f4079040e49abc79816c67" => :mavericks
  end

  depends_on "go" => :build
  depends_on "docker" => :recommended

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
      :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  resource "prebuilt-x86_64.tar.gz" do
    url "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v1.4.2/docker/prebuilt-x86_64.tar.gz",
      :using => :nounzip
    version "1.4.2"
    sha256 "cb2225591fb379cba8e8e3a6f5b9f7eda3cac9d04973a9b03cda02de20a6e7e0"
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
      resource("prebuilt-x86_64.tar.gz").stage do
        system *%W[go-bindata -pkg docker -nocompress -nomemcopy -nometadata
                   -o #{dir}/executors/docker/bindata.go prebuilt-x86_64.tar.gz]
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
