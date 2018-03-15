require "language/go"

class Gron < Formula
  desc "Make JSON greppable"
  homepage "https://github.com/tomnomnom/gron"
  url "https://github.com/tomnomnom/gron/archive/v0.5.1.tar.gz"
  sha256 "062462b8b6e884cd5731b0bc870e9a45f450e056f4367acccddb926079686560"
  head "https://github.com/tomnomnom/gron.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "69513942bdaf37db13e7c380bc5241ef7a1a7e778b186c4197e8fa8e177bd6fb" => :high_sierra
    sha256 "04dfab480e6fa4f718491d8b1c13929769260fb5330c62d5944a9b23c224005e" => :sierra
    sha256 "8b719a5634fc88a4fa10bea59524ba58209e0da61fcbcba99ce09830a0c2358a" => :el_capitan
  end

  depends_on "go" => :build

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "5df930a27be2502f99b292b7cc09ebad4d0891f4"
  end

  go_resource "github.com/nwidger/jsoncolor" do
    url "https://github.com/nwidger/jsoncolor.git",
        :revision => "75a6de4340e59be95f0884b9cebdda246e0fdf40"
  end

  go_resource "github.com/pkg/errors" do
    url "https://github.com/pkg/errors.git",
        :revision => "e881fd58d78e04cf6d0de1217f8707c8cc2249bc"
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
