require "language/go"

class Gron < Formula
  desc "Make JSON greppable"
  homepage "https://github.com/tomnomnom/gron"
  url "https://github.com/tomnomnom/gron/archive/v0.6.0.tar.gz"
  sha256 "fe75b1b4922b591723f48cb9cd2c31cb60bb3ab9f8d0398df75a08b781d8591c"
  head "https://github.com/tomnomnom/gron.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7851170e1feed7c87430f7af735f193cf295b5a4116d0f177296dd8fb000815" => :catalina
    sha256 "8250d3b6d9acc5bf1700a6513ab9df0df1a3e5660d2f984a4a903c234e6cd555" => :mojave
    sha256 "7838ab1c751a11027f31b7b4dac4f7a83402b04a7eef522edeb15735846dfd81" => :high_sierra
    sha256 "fa5310f4ac25091387f24e5dd4bb0364db432ebc9f3273da371cbd35116af09e" => :sierra
    sha256 "23c3378ea69d5936b6966608942a0769c4adad0cdeabb9575e8b811b9b6c3a26" => :el_capitan
  end

  depends_on "go" => :build

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "2d684516a8861da43017284349b7e303e809ac21"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        :revision => "efa589957cd060542a26d2dd7832fd6a6c6c3ade"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "6ca4dbf54d38eea1a992b3c722a76a5d1c4cb25c"
  end

  go_resource "github.com/nwidger/jsoncolor" do
    url "https://github.com/nwidger/jsoncolor.git",
        :revision => "75a6de4340e59be95f0884b9cebdda246e0fdf40"
  end

  go_resource "github.com/pkg/errors" do
    url "https://github.com/pkg/errors.git",
        :revision => "816c9085562cd7ee03e7f8188a1cfd942858cded"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/tomnomnom").mkpath
    ln_s buildpath, buildpath/"src/github.com/tomnomnom/gron"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"gron"
  end

  test do
    assert_equal <<~EOS, pipe_output("#{bin}/gron", "{\"foo\":1, \"bar\":2}")
      json = {};
      json.bar = 2;
      json.foo = 1;
    EOS
  end
end
