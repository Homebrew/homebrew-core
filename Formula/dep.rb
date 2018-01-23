class Dep < Formula
  desc "Go dependency management tool"
  homepage "https://github.com/golang/dep"
  url "https://github.com/golang/dep/archive/v0.3.2.tar.gz"
  sha256 "327124953d76293eaba6001e17bb8a31371313ab39eed1fa9eac01f8b5c1de21"
  head "https://github.com/golang/dep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7627ee12c2bbf397c1be89d172bb1992f98900f4f073801b2b3b9cf16bf2fb55" => :high_sierra
    sha256 "98355e1caa1fe5668d3e8f1630a84b9f307611eb59119b90f94bd4734b222ada" => :sierra
    sha256 "cb51aeeb47448fd3f90582dacb4ab36cee116546f49038870eb611e82d47fb6d" => :el_capitan
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/golang/dep").install buildpath.children
    cd "src/github.com/golang/dep" do
      system "go", "build", "-o", bin/"dep", "-ldflags",
             "-X main.version=#{version}", ".../cmd/dep"
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
