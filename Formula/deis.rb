class Deis < Formula
  desc "The CLI for Deis Workflow"
  homepage "https://deis.io/"
  url "https://github.com/deis/workflow-cli/archive/v2.12.0.tar.gz"
  sha256 "5d4dbd7f21774b139013cf02c19b27b5a110b472744364ba26ad187f3200bf77"

  bottle do
    cellar :any_skip_relocation
    sha256 "6dea556ef879ceab2740f8cca4c2a41795e1b4bdb1e32c8b84112db7b3945949" => :sierra
    sha256 "68dafd171f6f48bb07be6fbcf0a5d751e1844ca3bd1a433126588360f3caa902" => :el_capitan
    sha256 "24482a9d0a0bdc44da340b9f368a4a1b40aab561a5dd33522d29e1979365f812" => :yosemite
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
