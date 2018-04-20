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
    sha256 "d966bceebf60bc830e7e89769d28e083a02450a443af8d3d2d8d61882eb9ddab" => :high_sierra
    sha256 "f1a18e5098e54f029ed6e495d9aeffe5e56b9428be55cfff3df2103d96016093" => :sierra
    sha256 "a6e76fe6cb823309673ba0a83cd1117f1c4179e2911954a20fcd589aa54c090f" => :el_capitan
    sha256 "9b3f18e2ccb4f700ab515c002d4ae6128c9e3ebbbc0ff8796b67d3e698205214" => :yosemite
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
