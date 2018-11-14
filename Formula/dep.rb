class Dep < Formula
  desc "Go dependency management tool"
  homepage "https://github.com/golang/dep"
  url "https://github.com/golang/dep.git",
      :tag      => "v0.5.0",
      :revision => "224a564abe296670b692fe08bb63a3e4c4ad7978"
  head "https://github.com/golang/dep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "582943ea885a3e996b81052ce226d090b7563b5a14a342197d8361e80ca13772" => :mojave
    sha256 "6c774e11ada19f1f1c71ba7b1d74d0f34290ab3657b316ee2b5f57a3aa633f0a" => :high_sierra
    sha256 "9cb09a385da8bd6a23fd147a3c8eed29a223ecd8919b10127b259dfd6921a4a0" => :sierra
    sha256 "7dc66f06e23b66f966540e80da1f16db9d9460edaf98338a66e4fdc935551160" => :el_capitan
  end

  depends_on "go"

  conflicts_with "deployer", :because => "both install `dep` binaries"

  def install
    ENV["GOPATH"] = buildpath
    arch = MacOS.prefer_64_bit? ? "amd64" : "386"
    (buildpath/"src/github.com/golang/dep").install buildpath.children
    cd "src/github.com/golang/dep" do
      ENV["DEP_BUILD_PLATFORMS"] = "darwin"
      ENV["DEP_BUILD_ARCHS"] = arch
      system "hack/build-all.bash"
      bin.install "release/dep-darwin-#{arch}" => "dep"
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
