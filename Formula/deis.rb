class Deis < Formula
  desc "The CLI for Deis Workflow"
  homepage "https://deis.io/"
  url "https://github.com/deis/workflow-cli/archive/v2.14.0.tar.gz"
  sha256 "974fa31606e17f9ca626f1a9777f6aaca3fa9b3563a7cfcb00fad6b075b7a489"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b42710ac5a33e312bf4d61d0754b794757a7eaa153e29cfaa12c5627024e6ce" => :sierra
    sha256 "fd04bc19928fcdf68b9401c53275d50c57c006fbb54dc45dfa4fc27de4892c77" => :el_capitan
    sha256 "e3c0aff48dbaa0baf502e6741624268b535cea2125618ec3230a41e7b706b183" => :yosemite
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
