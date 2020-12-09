class Dep < Formula
  desc "Go dependency management tool"
  homepage "https://github.com/golang/dep"
  url "https://github.com/golang/dep.git",
      tag:      "v0.5.4",
      revision: "1f7c19e5f52f49ffb9f956f64c010be14683468b"
  license "BSD-3-Clause"
  head "https://github.com/golang/dep.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5bd49a3da392e08bef0ae821a534bd699c4c3f6d116d90b53007477fbad6a374" => :big_sur
    sha256 "be9871f4e01aa179f9f3b32931838f21c5e64d33840ac36c8b601adeebb5e95b" => :catalina
    sha256 "a86103fd9d7349cde0906850b1adaaa4e9b6c787cb11b0a791127c9af16ede8a" => :mojave
  end

  deprecate! date: "2020-11-25", because: :repo_archived

  depends_on "go"

  conflicts_with "deployer", because: "both install `dep` binaries"

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
