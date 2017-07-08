class Deis < Formula
  desc "The CLI for Deis Workflow"
  homepage "https://deis.io/"
  url "https://github.com/deis/workflow-cli/archive/v2.16.0.tar.gz"
  sha256 "3a1dc98ef8904c62cbe32871047c42294c1de874ebfbf7dcb4beb4e1b2004144"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f42c1cda5de53a5adca7a0cb48c1f02b8c1ed2ba096805b3b23342b8d89e379" => :sierra
    sha256 "6bf202a40807a3a3bf53798509f09a866c7fc305251a7c65fbfa6331311a0ebb" => :el_capitan
    sha256 "6e9072eba5061388b0dea73e35f66deb62184fd57f9166118c81608c302da4bd" => :yosemite
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
