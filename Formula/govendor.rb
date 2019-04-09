class Govendor < Formula
  desc "Go vendor tool that works with the standard vendor file"
  homepage "https://github.com/kardianos/govendor"
  url "https://github.com/kardianos/govendor/archive/v1.0.9.tar.gz"
  sha256 "d303abf194838792234a1451c3a1e87885d1b2cd21774867b592c1f7db00551e"
  head "https://github.com/kardianos/govendor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5bcf9c902173a5ea922be49153fb3a5f59d44534a7f4dbbb5b9f536c0607fa6" => :mojave
    sha256 "38df7324a3a5292636a57c8c17cbdda94a0d529fa42f2e446f372a49b5697f26" => :high_sierra
    sha256 "5708cee7e053271235d433cc1f7450f10540129810016095db622652621dc528" => :sierra
    sha256 "52e2dd5debbd16a4da952ce16dd37d2697e16ba8509ff1e9a9551e7303ec6949" => :el_capitan
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"

    (buildpath/"src/github.com/kardianos/").mkpath
    ln_sf buildpath, buildpath/"src/github.com/kardianos/govendor"
    system "go", "build", "-o", bin/"govendor"
  end

  test do
    # Default HOMEBREW_TEMP is /tmp, which is actually a symlink to /private/tmp.
    # `govendor` bails without `.realpath` as it expects $GOPATH to be "real" path.
    ENV["GOPATH"] = testpath.realpath
    commit = "89d9e62992539701a49a19c52ebb33e84cbbe80f"
    (testpath/"src/github.com/project/testing").mkpath

    cd "src/github.com/project/testing" do
      system bin/"govendor", "init"
      assert_predicate Pathname.pwd/"vendor", :exist?, "Failed to init!"
      system bin/"govendor", "fetch", "-tree", "golang.org/x/crypto@#{commit}"
      assert_match commit, File.read("vendor/vendor.json")
      assert_match "golang.org/x/crypto/blowfish", shell_output("#{bin}/govendor list")
    end
  end
end
