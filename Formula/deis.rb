class Deis < Formula
  desc "The CLI for Deis Workflow"
  homepage "https://deis.io/"
  url "https://github.com/deis/workflow-cli/archive/v2.18.0.tar.gz"
  sha256 "886e3cd9642380ea92d0f76bc1b1114d32a010d4d577212f9396e3069a6b11ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "8bd80b147f2c84ab7ce4b29bcffe40ae7e279fd5e493958d8d909137fe0cfa70" => :mojave
    sha256 "f1a9bbbfe65041792e01e4f45b2805aca7fb3d3725aae71336f27987f6661d80" => :high_sierra
    sha256 "9a5e666e56d263cf75c838336534d1cbffd7eb51950aaad25630d0cb1f229f0b" => :sierra
    sha256 "7e8b9a9545b65a3d9d50566c7a01236313492388ffe0db7df62eba628408d414" => :el_capitan
    sha256 "1c6b8f51f68c214b508a16cddff08a8e36d78981aaae69638b862bb0315f76f2" => :yosemite
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
