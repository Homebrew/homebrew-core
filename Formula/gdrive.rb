require "language/go"

class Gdrive < Formula
  desc "Google Drive CLI Client"
  homepage "https://github.com/prasmussen/gdrive"
  url "https://github.com/prasmussen/gdrive/archive/2.1.0.tar.gz"
  sha256 "e3cbd0d28669753c914af7c4832319d32586f6257bbd5f10d950bc4ed8322429"
  head "https://github.com/prasmussen/gdrive.git"

  bottle do
    cellar :any_skip_relocation
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  go_resource "github.com/sabhiram/go-git-ignore" do
    url "https://github.com/sabhiram/go-git-ignore.git",
      :revision => "228fcfa2a06e870a3ef238d54c45ea847f492a37"
  end

  go_resource "github.com/soniakeys/graph" do
    url "https://github.com/soniakeys/graph.git",
      :revision => "c265d9676750b13b9520ba4ad4f8359fa1aed9fd"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
      :revision => "fb93926129b8ec0056f2f458b1f519654814edf0"
  end

  go_resource "golang.org/x/oauth2" do
    url "https://go.googlesource.com/oauth2.git",
      :revision => "7e9cd5d59563851383f8f81a7fbb01213709387c"
  end

  go_resource "google.golang.org/api" do
    url "https://github.com/google/google-api-go-client.git",
      :revision => "9737cc9e103c00d06a8f3993361dec083df3d252"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/prasmussen/"
    ln_sf buildpath, buildpath/"src/github.com/prasmussen/gdrive"
    Language::Go.stage_deps resources, buildpath/"src"
    system "godep", "go", "build", "-o", "gdrive", "."
    bin.install "gdrive"
    doc.install "README.md"
  end

  test do
    system "#{bin}/gdrive", "help"
  end
end
