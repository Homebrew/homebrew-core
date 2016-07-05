require "language/go"

class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/v0.11.0.tar.gz"
  sha256 "7a7023aff20ba695706a262b8c07840ee28b939ea6358efbb69ab77da04f0052"
  head "https://github.com/Masterminds/glide.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b28193ddb387952ff83481504615502a58193c5ff839071d2025b2d8179b7086" => :el_capitan
    sha256 "edc4bf6fd959511012d300b85f438f0cf8eacd53a135155052a0fafbf2d56142" => :yosemite
    sha256 "ce54f1204502d1c568526a9450e88fa80593c375c990ce12d9ab7b388c7bcae2" => :mavericks
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
