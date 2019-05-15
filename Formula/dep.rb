class Dep < Formula
  desc "Go dependency management tool"
  homepage "https://github.com/golang/dep"
  url "https://github.com/golang/dep.git",
      :tag      => "0.5.2",
      :revision => "5025d70ef6f298075c16c835a78924f2edd37502"
  head "https://github.com/golang/dep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9fd0b229d77f58fd489260eba663f2f64de165ff85ce0d59c5a9817e79c701c" => :mojave
    sha256 "5278b1bf179af3d70a5189b3be3bb333251fe2e305fa42a774ef3260ac6144c3" => :high_sierra
    sha256 "77a3bbe268ceb1c73dada293098bfe934f7dd997e9a6268873de74601ed2377a" => :sierra
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
