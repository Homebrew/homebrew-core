class Deis < Formula
  desc "The CLI for Deis Workflow"
  homepage "https://deis.io/"
  url "https://github.com/deis/workflow-cli/archive/v2.17.0.tar.gz"
  sha256 "fb28055bd00e775ad28eace087b8ddf0c8ca69ec8aa76251ce8f5667fd6b41eb"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc3b3150ba370b75c7d7312fb30bcf65349e8d081c03f4a0ce322a09d229e838" => :sierra
    sha256 "b1ee5164f6dfe2ff0b83e1dccd26294b552c5564e5a56e26f8626f291a0d395f" => :el_capitan
    sha256 "a6d9216f31cdd813af722eabfb4a2eb064689f8b4fd2d882e4581baac38bf9ff" => :yosemite
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
