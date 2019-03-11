class Dep < Formula
  desc "Go dependency management tool"
  homepage "https://github.com/golang/dep"
  url "https://github.com/golang/dep.git",
      :tag      => "v0.5.1",
      :revision => "faa6189302b8a862e5612d332ff3755c19784749"
  head "https://github.com/golang/dep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ae2b134e3ae0db5f49767820b8a29ba302a3e850be0febb108ceccdb6dbc2a4" => :mojave
    sha256 "185d8734c3009053c1b7eca70e61e2749ca83fe3573257a95e4c7f173f8eacd8" => :high_sierra
    sha256 "596d056ca96c9d4fd992f16362f78f64526a3034112e775ee3912f26ab5d4158" => :sierra
  end

  depends_on "go"

  conflicts_with "deployer", :because => "both install `dep` binaries"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/golang/dep").install buildpath.children
    cd "src/github.com/golang/dep" do
      ENV["DEP_BUILD_PLATFORMS"] = "darwin"
      ENV["DEP_BUILD_ARCHS"] = "amd64"
      system "hack/build-all.bash"
      bin.install "release/dep-darwin-amd64" => "dep"
      prefix.install_metafiles
    end
  end

  test do
    # Default HOMEBREW_TEMP is /tmp, which is actually a symlink to /private/tmp.
    # `dep` bails without `.realpath` as it expects $GOPATH to be a "real" path.
    ENV["GOPATH"] = testpath.realpath
    project = testpath/"src/github.com/project/testing"
    (project/"hello.go").write <<~EOS
      package main

      import "fmt"
      import "github.com/Masterminds/vcs"

      func main() {
          fmt.Println("Hello World")
      }
    EOS
    cd project do
      system bin/"dep", "init"
      assert_predicate project/"vendor", :exist?, "Failed to init!"
      inreplace "Gopkg.toml", /(version = ).*/, "\\1\"=1.11.0\""
      system bin/"dep", "ensure"
      assert_match "795e20f90", (project/"Gopkg.lock").read
      output = shell_output("#{bin}/dep status")
      assert_match %r{github.com/Masterminds/vcs\s+1.11.0\s}, output
    end
  end
end
