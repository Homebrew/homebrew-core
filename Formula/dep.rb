class Dep < Formula
  desc "Go dependency management tool"
  homepage "https://github.com/golang/dep"
  url "https://github.com/golang/dep/archive/v0.3.0.tar.gz"
  sha256 "7d816ffb14f57c4b01352676998a8cda9e4fb24eaec92bd79526e1045c5a0c83"
  head "https://github.com/golang/dep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a7279febe0f7a6b3bff7ce46edfc35bd961b169b59a50b289f1f664dceac75d" => :sierra
    sha256 "1a4123ee7093682793f8f4f7707310b9a9bf3ba9f68efd95f4fbf949e38a177b" => :el_capitan
    sha256 "7a583a32547bb8043c0b2d7d3c78ff6fb4bc211f2b5e271a56fb63d490f395e5" => :yosemite
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/golang/dep").install buildpath.children
    cd "src/github.com/golang/dep" do
      system "go", "build", "-o", bin/"dep", ".../cmd/dep"
      prefix.install_metafiles
    end
  end

  test do
    # Default HOMEBREW_TEMP is /tmp, which is actually a symlink to /private/tmp.
    # `dep` bails without `.realpath` as it expects $GOPATH to be a "real" path.
    ENV["GOPATH"] = testpath.realpath
    project = testpath/"src/github.com/project/testing"
    (project/"hello.go").write <<-EOS.undent
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
