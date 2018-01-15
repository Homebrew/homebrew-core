require "language/go"

class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/jwilder/docker-gen"
  url "https://github.com/jwilder/docker-gen/archive/0.7.4.tar.gz"
  sha256 "7951b63684e4ace9eab4f87f0c5625648f8add2559fa7779fabdb141a8a83908"

  depends_on "go" => :build

  go_resource "github.com/agtorre/gocolorize" do
    url "https://github.com/agtorre/gocolorize.git",
        :revision => "99fea4bc9517f07eea8194702cb7076f4845b7de"
  end

  go_resource "github.com/robfig/glock" do
    url "https://github.com/robfig/glock.git",
        :revision => "428181ba14e0e3722090fe6e63402643a099e8bd"
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git",
        :revision => "fbec762f837dc349b73d1eaa820552e2ad177942"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jwilder/docker-gen").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/robfig/glock" do
      system "go", "install"
    end

    cd "src/github.com/jwilder/docker-gen" do
      system buildpath/"bin/glock", "sync", "github.com/jwilder/docker-gen"
      system "go", "build", "-ldflags", "-X main.buildVersion=#{version}", "-o",
             bin/"docker-gen", "./cmd/docker-gen"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
