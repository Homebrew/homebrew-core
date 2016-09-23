require "language/go"

class GitlabCiMultiRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner"
  url "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git",
      tag: "v1.6.0",
      revision: "01b3ea12f848f6ca3d29b32bd3a4fb30a443d7f4"
  head "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f40e96f930549f1f6f39556fe8d695a2627b80002b25711db753b0e125a2c562" => :sierra
    sha256 "9a66fbd01bd3204ea102871b70b198a72f755551c901d0f0f6e77d972392d7e7" => :el_capitan
    sha256 "0b1fff11c5883bf599072b8d97d2baf9a83c8806bcf8fbafa360533c0c7ec532" => :yosemite
    sha256 "03d8d0c78d2db024a286ab7813ca9e1f99cd40faac58744a5c1fbf0f78ec3396" => :mavericks
  end

  depends_on "go" => :build
  depends_on "docker" => :recommended

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
        revision: "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  resource "prebuilt-x86_64.tar.xz" do
    url "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v1.6.0/docker/prebuilt-x86_64.tar.xz",
        using: :nounzip
    version "1.6.0"
    sha256 "0dcdfb57bd4a6ed2f3d84848e44ae03f24a7428b21147f16cab7b47c6f14ecf9"
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
