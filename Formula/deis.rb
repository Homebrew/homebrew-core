class Deis < Formula
  desc "The CLI for Deis Workflow"
  homepage "https://deis.io/"
  url "https://github.com/deis/workflow-cli/archive/v2.13.0.tar.gz"
  sha256 "5a1f44e2bbfcfe4593e9d9ed5870029a9ac3b4ab0efd437d3dca2206ee31a067"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbb9f1aaeb34961b544372deef2474dbe8f3fdd2428551d4aa0de5a488b980cd" => :sierra
    sha256 "4885e332c7b00963e3cc816269d18ae0ec1e4125fe74add7695124fd0eac38b7" => :el_capitan
    sha256 "3e0c606e28928df6da3512edebf91d9f6dcd520d9af21dfbd19b36c8cd0b4344" => :yosemite
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    deispath = buildpath/"src/github.com/deis/workflow-cli"
    deispath.install Dir["{*,.git}"]

    cd deispath do
      system "glide", "install"
      system "go", "build", "-o", "build/deis",
        "-ldflags",
        "'-X=github.com/deis/workflow-cli/version.Version=v#{version}'"
      bin.install "build/deis"
    end
  end

  test do
    system bin/"deis", "logout"
  end
end
