require "language/go"

class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v5.8.1.tar.gz"
  sha256 "128cca9ab2fbf3451560558f990b9bf821981dddaa1d47026bd4e71a3d07f25b"
  head "https://github.com/mattn/jvgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3379c1f00e90881fb0e5d4f684cd62208065e0339f13d810480a2d4c7f45455" => :mojave
    sha256 "2bde2644eb0412fb14bc974926756e8cc5da2b7e9eec55af8a16dbae5a5ef9bc" => :high_sierra
    sha256 "c0ad60bf13a602161c77c1d1140ffc22c8c08680fc7ec3d47914b0f8159c5b93" => :sierra
  end

  depends_on "go" => :build

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        :revision => "efa589957cd060542a26d2dd7832fd6a6c6c3ade"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "6ca4dbf54d38eea1a992b3c722a76a5d1c4cb25c"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "5f9ae10d9af5b1c89ae6904293b14b064d4ada23"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
        :revision => "7922cc490dd5a7dbaa7fd5d6196b49db59ac042f"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/mattn"
    ln_s buildpath, buildpath/"src/github.com/mattn/jvgrep"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"jvgrep"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"jvgrep", "Hello World!", testpath
  end
end
