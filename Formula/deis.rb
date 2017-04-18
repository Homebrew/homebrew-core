class Deis < Formula
  desc "The CLI for Deis Workflow"
  homepage "https://deis.io/"
  url "https://github.com/deis/workflow-cli/archive/v2.13.0.tar.gz"
  sha256 "5a1f44e2bbfcfe4593e9d9ed5870029a9ac3b4ab0efd437d3dca2206ee31a067"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c30a6681470e836106d736a1b756ac2b92ca55449118007e024c2d53223a25f" => :sierra
    sha256 "0a9852a78d603299a5e579f070eb6811b6067da8f0c9ed97e06a7261dfa68c8a" => :el_capitan
    sha256 "6abec4d481fd7a748faca351c4474f59284fdede8ffab38a72cf3a132f83aef1" => :yosemite
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
