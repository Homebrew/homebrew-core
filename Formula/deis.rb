class Deis < Formula
  desc "The CLI for Deis Workflow"
  homepage "https://deis.io/"
  url "https://github.com/deis/workflow-cli/archive/v2.17.0.tar.gz"
  sha256 "fb28055bd00e775ad28eace087b8ddf0c8ca69ec8aa76251ce8f5667fd6b41eb"

  bottle do
    cellar :any_skip_relocation
    sha256 "7008d569dc9083361b32942914070a046dea54ae40eabdf988cc1cee5feea2f3" => :sierra
    sha256 "cace47c1a5475de809faffeb63970f9ddb428e18a532057dde6cd943595bade7" => :el_capitan
    sha256 "da47a3ab8ce03a5ab3860413b8c0bd89b78929a0e0aee0fa0a1d7e2720267bd6" => :yosemite
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
