require "language/go"

class Dockviz < Formula
  desc "Visualizing docker data"
  homepage "https://github.com/justone/dockviz"
  url "https://github.com/justone/dockviz.git",
    :tag => "v0.6.1",
    :revision => "b4f269312f7e80419ecca555bf20066d71ee5827"
  head "https://github.com/justone/dockviz.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "01e4173f4c4fb2a240fcfba6b3a584c16bdbf41da9406494b4a1a4e757c32e41" => :high_sierra
    sha256 "f7b9d5787315ee4cd82011beae7bd7a06d322001f014de09a7a78dfd6be734e6" => :sierra
    sha256 "fed1f250e52f6eb8620de68109d7a7ee8c998b6eaf636f8850c393f040127ca9" => :el_capitan
  end

  depends_on "go" => :build

  go_resource "github.com/docker/docker" do
    url "https://github.com/docker/docker.git",
        :revision => "8bb5a28eed5eba5651c6e48eb401c03be938b4c1"
  end

  go_resource "github.com/docker/go-units" do
    url "https://github.com/docker/go-units.git",
        :revision => "47565b4f722fb6ceae66b95f853feed578a4a51c"
  end

  go_resource "github.com/fsouza/go-dockerclient" do
    url "https://github.com/fsouza/go-dockerclient.git",
        :revision => "eb4b27262d9a41d4004d101c32e0598782a39415"
  end

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
        :revision => "1c38ed7ad0cc3d9e66649ac398c30e45f395c4eb"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"dockviz"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockviz --version")
  end
end
