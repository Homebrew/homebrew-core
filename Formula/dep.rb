class Dep < Formula
  desc "Go dependency management tool"
  homepage "https://github.com/golang/dep"
  url "https://github.com/golang/dep/archive/v0.3.2.tar.gz"
  sha256 "327124953d76293eaba6001e17bb8a31371313ab39eed1fa9eac01f8b5c1de21"
  head "https://github.com/golang/dep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "220bc273367e5613101047088a71cebad18fea6a5192d68905d4a12979f81877" => :high_sierra
    sha256 "1d38003db890e4239eb5f64564ba999ca0b9f1dfffa81c4261467563d6130dae" => :sierra
    sha256 "8a98b359a60c7cc4d477c3a2e060bd94c47722ae386142393fb68bbb6a1e1a0e" => :el_capitan
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
