require "language/go"

class Mpdviz < Formula
  desc "Standalone console MPD visualizer"
  homepage "https://github.com/lucy/mpdviz"
  url "https://github.com/lucy/mpdviz/archive/0.4.6.tar.gz"
  sha256 "c34243ec3f3d91adbc36d608d5ba7082ff78870f2fd76a6650d5fb3218cc2ba3"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 monterey:     "789287aa34c69bce8cc78fd7d8c38674a32968ca73b48b925db9aa094f2a2ba4"
    sha256 cellar: :any,                 big_sur:      "3be0538c899cc10de1c50b27e6540e2e87ce5017c86ba1d0adeed563876072d9"
    sha256 cellar: :any,                 catalina:     "f65d98aebf9bee4de6dce79983fe91b20f95d731be71999021639bdd7c8c14e9"
    sha256 cellar: :any,                 mojave:       "dcc5deb65626637f6a4182f96e1ccd441a462c55657e134d2277a70be8246278"
    sha256 cellar: :any,                 high_sierra:  "1f1b0b01dcfd1c37b7820ae93a9775abcd5b1abcdb8a5a4038d348e517b3c87a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b8b7f4496ea24badc34b33402603a2fbba5b92d0eecdddfbf9ff23b6e7b92db5"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"

  go_resource "github.com/lucy/go-fftw" do
    url "https://github.com/lucy/go-fftw.git",
        revision: "37bfa0d3053b133f7067e9524611a7a963294124"
  end

  go_resource "github.com/lucy/pflag" do
    url "https://github.com/lucy/pflag.git",
        revision: "20db95b725d76759ba16e25ae6ae2ec67bf45216"
  end

  go_resource "github.com/lucy/termbox-go" do
    url "https://github.com/lucy/termbox-go.git",
        revision: "a09edf97f26bd0a461d4660b5322236ecf9d4397"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
        revision: "36f63b8223e701c16f36010094fb6e84ffbaf8e0"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "mpdviz"
    bin.install "mpdviz"
  end
end
