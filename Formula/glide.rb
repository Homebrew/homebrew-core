require "language/go"

class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/v0.11.1.tar.gz"
  sha256 "3c4958d1ab9446e3d7b2dc280cd43b84c588d50eb692487bcda950d02b9acc4c"
  head "https://github.com/Masterminds/glide.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "270ba9b495ba14409fab440b4cc45c9ae4793ad2fa77e59c7f838dc9a0f34700" => :el_capitan
    sha256 "de848bffe9a1f512a7a9c067ef13309c01e6bb9ee2a8f40ea888547613ac8cc9" => :yosemite
    sha256 "7e393a090ea6dc107fde98fd3d1e6da914269589efbaae3c26fbfb20ff2d50eb" => :mavericks
  end

  depends_on "go" => :build

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
      :revision => "a83829b6f1293c91addabc89d0571c246397bbf4"
  end

  go_resource "github.com/Masterminds/vcs" do
    url "https://github.com/Masterminds/vcs.git",
      :revision => "fbe9fb6ad5b5f35b3e82a7c21123cfc526cbf895"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "71f57d300dd6a780ac1856c005c4b518cfd498ec"
  end

  go_resource "github.com/Masterminds/semver" do
    url "https://github.com/Masterminds/semver.git",
      :revision => "8d0431362b544d1a3536cca26684828866a7de09"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/Masterminds/"
    ln_s buildpath, buildpath/"src/github.com/Masterminds/glide"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "glide", "-ldflags", "-X main.version #{version}"
    bin.install "glide"
  end

  test do
    version = pipe_output("#{bin}/glide --version")
    assert_match /#{version}/, version
  end
end
