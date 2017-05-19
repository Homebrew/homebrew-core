class Deis < Formula
  desc "The CLI for Deis Workflow"
  homepage "https://deis.io/"
  url "https://github.com/deis/workflow-cli/archive/v2.14.1.tar.gz"
  sha256 "6f875d70663b85c3f832d7f00481a19876c58a44e1e7fd25876e114d065c70de"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a51e1715ef658de9ddc2ed147dea6ed46bea26afaa7cb69d3b725013fc3e58a" => :sierra
    sha256 "5e1afa5e30f640521dd1be3f15e6863c11b51605e2576e627561a0a14c8aec9d" => :el_capitan
    sha256 "2a03389c9e47da6bebe21cb0c1a2492972cd03e25b60c3273cb5986fad057080" => :yosemite
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
