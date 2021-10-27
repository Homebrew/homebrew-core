class Dep < Formula
  desc "Go dependency management tool"
  homepage "https://github.com/golang/dep"
  url "https://github.com/golang/dep.git",
      tag:      "v0.5.4",
      revision: "1f7c19e5f52f49ffb9f956f64c010be14683468b"
  license "BSD-3-Clause"
  head "https://github.com/golang/dep.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a99c5d8b805b93143f1d00559188d270d96578b8a39d66ba21ba01abd7f2b7b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd66e578cf33fafc42cecb83d80638b320a9b6a050cb769402532b7ec5d3f8ad"
    sha256 cellar: :any_skip_relocation, monterey:       "1cb18d2256fceead36d957b8b0b27819b81437d5b69fbfbbaba9fc4a1df21738"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bd49a3da392e08bef0ae821a534bd699c4c3f6d116d90b53007477fbad6a374"
    sha256 cellar: :any_skip_relocation, catalina:       "be9871f4e01aa179f9f3b32931838f21c5e64d33840ac36c8b601adeebb5e95b"
    sha256 cellar: :any_skip_relocation, mojave:         "a86103fd9d7349cde0906850b1adaaa4e9b6c787cb11b0a791127c9af16ede8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7917c664bc0a540e065deb1e14671a5a818823672ec7a5a5caee34eb8feb664"
  end

  deprecate! date: "2020-11-25", because: :repo_archived

  depends_on "go"

  conflicts_with "deployer", because: "both install `dep` binaries"

  # Allow building on Apple ARM
  patch :DATA

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    platform = OS.kernel_name.downcase

    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/golang/dep").install buildpath.children
    cd "src/github.com/golang/dep" do
      ENV["DEP_BUILD_PLATFORMS"] = platform
      ENV["DEP_BUILD_ARCHS"] = arch
      system "hack/build-all.bash"
      bin.install "release/dep-#{platform}-#{arch}" => "dep"
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

__END__
diff --git a/hack/build-all.bash b/hack/build-all.bash
index 58d5bc2d..0c574a45 100755
--- a/hack/build-all.bash
+++ b/hack/build-all.bash
@@ -50,7 +50,7 @@ for OS in ${DEP_BUILD_PLATFORMS[@]}; do
     else
       CGO_ENABLED=0
     fi
-    if [[ "${ARCH}" == "ppc64" || "${ARCH}" == "ppc64le" || "${ARCH}" == "s390x" || "${ARCH}" == "arm" || "${ARCH}" == "arm64" ]] && [[ "${OS}" != "linux" ]]; then
+    if [[ "${ARCH}" == "ppc64" || "${ARCH}" == "ppc64le" || "${ARCH}" == "s390x" || "${ARCH}" == "arm" ]] && [[ "${OS}" != "linux" ]]; then
         # ppc64, ppc64le, s390x, arm and arm64 are only supported on Linux.
         echo "Building for ${OS}/${ARCH} not supported."
     else
